# Mechanism

class Mechanism

  attr_reader

  def initialize(game)
    @game = game
    @board = @game.board
  end

  def string_to_player(string)
    player = @game.players.select {|player| player.name == string}
    return player[0]
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

  def move_player(mover, to_string, moved = self)
    to = string_to_city(to_string)
    moved_current_city = string_to_city(moved.location)
    mover.move_pawn(to, moved)
    moved_current_city.pawn_move_from_city(moved)
    to.pawn_move_to_city(moved)
  end

  def deal_cards(from, number = 1, player)
    from.pop(number)
  end

  def discard_card_from_player_hand(player, card)
    player.discard_to_player_discard_pile(card)
    card.discard_to_player_discard_pile
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
  end

  def give_card_to_another_player(giver, receiver, card)
    giver.cards.delete(card)
    put_player_cards_into_hand([card], receiver)
  end



  def put_player_cards_into_hand(dealt_cards, player)
    player.put_cards_into_hand(dealt_cards)
    if player.has_epidemic_card?
      puts "You got an epidemic card!"
      player.discard_epidemic_card_to_discard_pile
      #perform epidemic card actions
    end
    dealt_cards.each do |card|
      card.taken_by_a_player(player)
    end
    while player.toss_cards?
      player_to_discard_in_hand(player)
    end
  end

  def player_to_discard_in_hand(player)
    puts player.name.to_s + ", you have more than 7 cards currently. These are your cards in hand : " + player.cards_in_hand_description.to_s
    puts "Let's discard cards one by one."
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




end
