# Mechanism

class Mechanism

  attr_reader :board

  def initialize(game)
    @game = game
    @board = @game.board
  end

  def string_to_player(string)
    player = @game.players.select {|player| player.name == string}
    return player[0]
  end

  def symbol_to_player(symbol)
    player = @game.players.select {|player| player.role == symbol}
    return player[0]
  end

  def symbol_to_player_card(symbol)
    cards = @game.player_cards.select {|card| card.type == :event}
    card = cards.select {|card| card.event == symbol}
    return card[0]
  end

  def string_to_player_card(string)
    if @board.player_card_event_names.include?(string)
      card = @board.player_cards.select {|card| card.event == string.to_sym}
    else
      card = @board.player_cards.select {|card| card.name == string}
    end
    return card[0]
  end

  def string_to_infection_card(string)
    card = @board.infection_cards.select {|card| card.cityname == string}
    return card[0]
  end

  def string_to_city(string)
    city = @board.cities.select {|city| city.name == string}
    return city[0]
  end

  def move_player(mover, to_string, moved = player)
    to = string_to_city(to_string)
    moved_current_city = string_to_city(moved.location)
    mover.move_pawn(to, moved)
    moved_current_city.pawn_move_from_city(moved)
    to.pawn_move_to_city(moved)
  end

  def deal_cards(from, number)
    from.pop(number)
  end

  def deal_known_card(from, card)
    from.delete(card)
  end

  def discard_card(to_pile, card)
    to_pile << card
  end

  def discard_card_from_player_hand(player, card)
    if card.type == :event && card.value == 0
      player.discard_from_game(card)
      card.discard_from_game
    else
      player.discard_to_player_discard_pile(card)
      card.discard_to_player_discard_pile
      discard_card(@game.player_discard_pile, card)
    end
  end

  def treat(player, city, color, var_in_game_class, reset, number = 1)
    #reset means all cubes of that color is removed in a treat.
    reset = true if player.role == :medic

    if reset
      reduced = city.disease_reset(color)
      puts "All cubes of color " +color.to_s+ " have been removed in "+city.name
    else
      city.treat(color, number)
      reduced = number
      puts number.to_s + " cubes of color " + color.to_s + " have been removed in "+city.name
    end

    var_in_game_class.increase_cubes_available(reduced)

  end

  def build_research_st(player, location)
    @board.count_research_station
    if @board.research_station_available > 0
      location.build_research_st
      puts "A research station has been built in "+location.name
      puts "Updated cities with research station : " + @board.research_st_cities.to_s
      puts
    else
      puts "You have built 6 research stations (max). There are currently a research station in each of the following cities : " + @board.research_st_cities.to_s
      print "You need to remove one research station. Proceed? 'y' or 'n'"
      answer = gets.chomp
      if answer == 'n'
        return "Build Research Station has been cancelled"
      elsif answer == 'y'
        satisfied = false
        while !satisfied
          print "Choose a city to remove its research station!"
          removed_city_string = gets.chomp
          removed_city = string_to_city(removed_city_string)
          if removed_city == nil || !removed_city.research_st
            puts "City unrecognized or doesn't have a research center. Try again!"
          else
            satisfied = true
            removed_city.remove_research_st
            location.build_research_st
            puts "Research station has been removed from " + removed_city.name + " and a research station has been built in " + location.name
          end
        end
      else
        puts "Only input 'y' or 'n'!"
      end
    end
    @board.count_research_station
  end

  def give_card_to_another_player(giver, receiver, card)
    giver.cards.delete(card)
    put_player_cards_into_hand([card], receiver)
  end

  def put_player_cards_into_hand(dealt_cards, player)
    player.put_cards_into_hand(dealt_cards)
    if player.has_epidemic_card?
      puts "You got an epidemic card! The epidemic card is discarded out of the game."
      puts "The following happens in an epidemic : "
      puts "1. Infection Rate is elevated."
      puts "2. Infect the City in the Infection Card at the bottom of the Infection Deck with 3 cubes of its original color. Then discard the card to the Infection Discard Pile."
      puts "3. Shuffle all the cards in the Infection Discard Pile and put all of them back on top of the Infection Deck."
      epidemic_card = player.discard_epidemic_card_to_discard_pile
      @game.discard_card(@game.player_discard_pile, epidemic_card)
      #perform epidemic card actions
    end
    dealt_cards.each do |card|
      card.taken_by_a_player(player)
    end
    while player.toss_cards?
      player_to_discard_in_hand_more_than_7(player)
    end
  end

  def player_to_discard_in_hand_more_than_7(player)
    puts player.name.to_s + ", you have more than 7 cards currently. Let's discard one by one."
    player_to_discard_in_hand(player)
  end

  def player_to_discard_in_hand(player)
    puts "These are your cards in hand : " + player.cards_in_hand_description.to_s
    card_discarded = prompt_card_to_discard(player)
    discard_card_from_player_hand(player, card_discarded)
    puts card_discarded.cityname + " has been discarded to Player Discard Pile." if card_discarded.type == :player
    puts card_discarded.event.to_s + " has been discarded to Player Discard Pile." if card_discarded.type == :event
  end

  def prompt_card_to_discard(player)
    satisfied = false
    while !satisfied
      puts "Pick a card event or city name to discard!"
      card_id_string = gets.chomp
      if player.names_of_player_cards_in_hand.include?(card_id_string)
        chosen_card = player.player_cards_in_hand.select {|card| card.cityname == card_id_string}
      elsif player.desc_of_event_cards_in_hand.include?(card_id_string)
        chosen_card = player.event_cards_in_hand.select {|card| card.event.to_s == card_id_string}
      end
      if chosen_card.size == 0
        puts "That city name can't be found. Make sure capitalization is correct. For 'St Petersburg', no period is required after St"
      else chosen_card.size == 1
        satisfied = true
      end
    end
    return chosen_card[0]
  end

  def epidemic_action
    #Update Infection Rate Index.
    @game.increase_infection_rate

    #Infect the bottom city in the Infection Deck with 3 cubes.
    infection_card = @game.infection_deck.shift(1)
    discard_card(@game.infection_discard_pile, infection_card)
    infection_card.reveal

    infected_city = string_to_city(infection_card.cityname)
    infected_city_original_color = infected_city.original_color
    puts "The revealed infection card is " + infection_card.cityname + " and its original color is " + infected_city_original_color.to_s
    perform_infect(@game.board.infected_city, infected_city_original_color, 3)

    # Shuffle cards in the infection discard pile and put them on top of the Infection Deck.
    @game.infection_discard_pile.shuffle!
    @game.infection_deck += @game.infection_discard_pile
    @game.infection_discard_pile = []
  end

  def perform_infect(city, color, number_of_cubes)
    existing_cubes = city.color_count
    if existing_cubes + number_of_cubes <= 3
      city.infect(color, number_of_cubes)
      reduce_color_cube_available(color, number_of_cubes)
      puts "Outbreak doesn't happen."
      puts
      if @game.lose?
        @game.game_over?
      end
    else
      if !@game.lose?
        city.outbreak_happens
        neighbors_names = ""
        city.neighbors.each do |neighbor|
          if !neighbor.outbreak
            neighbors_names + " " + neighbor.name
            perform_infect(neighbor, color, 1)
          end
        end
        puts "Outbreak on this city! Affected cities : "+neighbors_names
        @game.increase_outbreak_index
      else
        @game.game_over?
      end
    end
    @game.board.cities.each do |city|
      city.outbreak_reset
    end
  end

  def reduce_color_cube_available(color, number = 1)
    case color
    when :red
      @game.red_disease.reduce_cubes_available(number)
    when :yellow
      @game.yellow_disease.reduce_cubes_available(number)
    when :black
      @game.black_disease.reduce_cubes_available(number)
    when :blue
      @game.blue_disease.reduce_cubes_available(number)
    end
  end




end
