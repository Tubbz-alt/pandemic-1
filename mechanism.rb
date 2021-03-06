# Mechanism

require_relative 'game'
require_relative 'player'
require 'colorize'

class Mechanism

  attr_reader :board
  attr_accessor :players

  def initialize(game)
    @game = game
    @board = @game.board
    @players = []
  end

  def string_to_player(string)
    player = @game.players.select {|player| player.name == string}
    return player[0]
  end

  def symbol_to_player(symbol)
    player = @players.select {|player| player.role == symbol}
    return player[0]
  end

  def symbol_to_player_card(symbol)
    cards = @board.player_cards.select {|card| card.type == :event}
    card = cards.select {|card| card.event == symbol}
    return card[0]
  end

  def string_to_player_card(string)
    if @board.player_cards_event_names.include?(string)
      card = @board.player_cards_events.select {|event_card| event_card.event == string.to_sym}
    else
      card = @board.player_cards_cities.select {|player_card| player_card.cityname == string}
    end
    return card[0]
  end

  def string_to_player_discard_pile_card(string, player)
    event_cards_in_pdp = @game.player_discard_pile.select {|card| card.type == :event}
    player_cards_in_pdp = @game.player_discard_pile.select {|card| card.type == :player}

    event_cards = event_cards_in_pdp.collect {|card| card.event}
    player_cards = player_cards_in_pdp.collect {|card| card.cityname}

    if event_cards.include?(string.to_sym)
      card = event_cards_in_pdp.select {|card| card.event == string.to_sym}
    else
      card = player_cards_in_pdp.select {|card| card.cityname == string}
    end
    return card[0]
  end

  def string_to_players_player_card(string, player)
    event_cards_in_hand = player.cards.select {|card| card.type == :event}
    player_cards_in_hand = player.cards.select {|card| card.type == :player}

    event_cards = event_cards_in_hand.collect {|card| card.event}
    player_cards = player_cards_in_hand.collect {|card| card.cityname}

    if event_cards.include?(string.to_sym)
      card = event_cards_in_hand.select {|card| card.event == string.to_sym}
    else
      card = player_cards_in_hand.select {|card| card.cityname == string}
    end
    return card[0]
  end


  def string_to_infection_card_in_discard_pile(string)
    card = @game.infection_discard_pile.select {|card| card.cityname == string}
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
      print "All cubes of color "

      case color
      when :red
        print color.to_s.red
      when :black
        print color.to_s.black.on_white
      when :yellow
        print color.to_s.yellow
      when :blue
        print color.to_s.blue
      end

      puts " have been removed in " + city.name
      puts
    else
      city.treat(color, number)
      reduced = number

      case color
      when :red
        print number.to_s.red + " " + color.to_s.red
      when :black
        print number.to_s.black.on_white + " " + color.to_s.black.on_white
      when :yellow
        print number.to_s.yellow + " " + color.to_s.yellow
      when :blue
        print number.to_s.blue + " " + color.to_s.blue
      end

      puts " cubes have been removed in " + city.name
      puts
    end

    var_in_game_class.increase_cubes_available(reduced)

  end

  def build_research_st(player, location)
    @board.count_research_station
    if @board.research_station_available > 0
      location.build_research_st
      print "A research station has been built in "
      print_city_name_in_color(location)
      puts
      print "Updated cities with research station : "
      cities = @game.board.research_station_cities
      cities.each do |city|
        print_city_name_in_color(city)
        print ". "
      end
      puts
    else
      print "You have built 6 research stations (max). There are currently a research station in each of the following cities : "
      cities = @game.board.research_station_cities
      cities.each do |city|
        print_city_name_in_color(city)
        print ". "
      end
      puts
      print "You need to remove one research station. Proceed? ('y' or 'n') "
      answer = gets.chomp
      if answer.downcase == 'n'
        return "Build Research Station has been cancelled"
      elsif answer.downcase == 'y'
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
      puts
      puts "The following happens in an epidemic : "
      puts "1. Infection Rate is elevated."
      puts "2. Infect the City in the Infection Card at the bottom of the Infection Deck with 3 cubes of its original color. Then discard the card to the Infection Discard Pile."
      puts "3. Shuffle all the cards in the Infection Discard Pile and put all of them back on top of the Infection Deck."
      puts
      epidemic_card = player.discard_epidemic_card_to_discard_pile
      discard_card(@game.player_discard_pile, epidemic_card)
      epidemic_action
    end
    dealt_cards.each do |card|
      card.taken_by_a_player(player)
    end
    while player.toss_cards?
      player_to_discard_in_hand_more_than_7(player)
    end
  end

  def player_to_discard_in_hand_more_than_7(player)
    print player.name.to_s + ", you have more than 7 cards currently. Let's discard one by one. "

    display_player_cards_in_color(player)
    event_cards_to_discard = player.event_cards_in_hand

    while event_cards_to_discard.size > 0
      print "You can use your event cards. Your event cards are : "
      event_cards_to_discard_names = event_cards_to_discard.collect {|card| card.event}
      puts event_cards_to_discard_names.to_s
      event_card = which_event_card_to_use(player)
      if !event_card.nil?
        case event_card.event
        when :Resilient_Population

          satisfied = false
          while !satisfied
            print "Which city name has Resilient Population? This city will have its infection card removed from the infection disard pile. Type 'cancel' to cancel. "
            answer = gets.chomp
            if answer.downcase == "cancel"
              puts "Use of Resilient City cancelled."
              puts
              satisfied = true
            else
              city_card = string_to_infection_card_in_discard_pile(answer)
              if !city_card.nil?
                satisfied = true
                deal_known_card(@game.infection_discard_pile, city_card)
                city_card.remove_from_game
                discard_card_from_player_hand(player, event_card)
                puts city_card.cityname + " infection card has been removed from the Infection Discard Pile. Event card Resilient City has been discarded."
                puts
              else
                puts "That city name can't be found. Make sure capitalization is correct. For 'St Petersburg', no period is required after St, try again!"
              end
            end
          end

        when :Government_Grant

          location_obtained = false
          while !location_obtained
            print "Where to put research center in? Type 'cancel' to cancel this. "
            location_string = gets.chomp
            if location_string.downcase == 'cancel'
              location_obtained = true
              puts "Event usage cancelled."
              puts
            else
              location = string_to_city(location_string)
              if location.nil?
                puts "City unrecognized. Try again!"
              else
                location_obtained = true
                build_research_st(player, location)
                puts "A research station has been added to that city."
                discard_card_from_player_hand(player, event_card)
              end
            end
          end

        when :Airlift

          #Find the person who's moved.
          moved_confirmation = false
          destination_confirmation = false
          executed = false

          while !moved_confirmation
            print "You chose airlift event, which player's name do you wish to be airlifted? Type 'cancel' to cancel this event. "
            moved_string = gets.chomp
            if moved_string.downcase == "cancel"
              puts "Airlift event cancelled."
              puts
              moved_confirmation = true
              destination_confirmation = true
              executed = false
            else
              moved = string_to_player(moved_string)
              if !moved.nil?
                moved_confirmation = true
                puts moved.name + " is chosen."
              else
                puts "Please input the correct player's name. Try again!"
              end
            end
          end

          #Find where to move the moved person.
          while !destination_confirmation
            puts "Where do you want to airlift " + moved.name + " to? Input city name! Type 'cancel' to cancel this event."
            destination_string = gets.chomp
            if destination_string.downcase == "cancel"
              puts "Airlift event cancelled."
              puts
              destination_confirmation = true
              executed = false
            else
              destination = string_to_city(destination_string)
              if !destination.nil?
                destination_confirmation = true
                move_player(player, destination.name, moved)
                moved.name + " is airlifted from " + moved.location + " to " + destination.name
                executed = true
              else
                puts "That city name can't be found. Make sure capitalization is correct. For 'St Petersburg', no period is required after St"
              end
            end
          end

          if executed
            medic_automatic_treat_cured(moved, destination) if moved.role == :medic
            discard_card_from_player_hand(player, event_card)
          end

        when :One_Quiet_Night

          print "Do you confirm using this event in this turn? Type 'y' to confirm. "
          answer = gets.chomp
          if answer.downcase != 'y'
            puts "Action cancelled."
            puts
          else
            current_turn_index = @game.round.turns.compact.size - 1
            @game.round.turns[current_turn_index].one_quiet_night_mode
            discard_card_from_player_hand(player, event_card)
            puts "One Quiet Night is in effect. Event card is discarded from player's hand."
            puts
          end

        when :Forecast

          top_6_infection_cards = deal_cards(@game.infection_deck, 6)
          puts "The 6 cards at the top of the infection deck is : "
          top_6_infection_cards.each_with_index do |card, idx|
            puts card.cityname + ", index = " + (idx+1).to_s
          end
          puts "The state of these cities are : "
          top_6_infection_cards.each do |card|
            city = string_to_city(card.cityname)
            print city.name + " : " + city.color_count.to_s + ". Neighbors : "
            neighbors_states = ""
            city.neighbors.each {|neighbor| neighbors_states += (neighbor.name + " : " + neighbor.color_count.to_s + ". ")}
            puts neighbors_states
            puts
          end
          new_6 = []
          inputed = []
          counter = 0
          puts "Rearrange these 6 cards by answering the following : "
          while counter <= 5
            idx_satisfied = false
            while !idx_satisfied
              print "Old index of new index + " + (counter+1).to_s + ", (1 refers to bottom of the 6) = "
              answer = gets.chomp.to_i
              if answer == 0
                puts "Not a valid integer (1-6)."
              elsif inputed.include?(answer)
                put "You have used that old index before. Choose another number!"
              else
                new_6 << top_6_infection_cards[answer-1]
                inputed << answer
                idx_satisfied = true
              end
            end
            counter += 1
          end
          @game.infection_deck += new_6
          discard_card_from_player_hand(player, event_card)
          puts "These 6 cards have been returned to the top of the infection deck. Their order, from the bottom of the deck, is :"
          new_6.each {|card| puts card.cityname}
          puts
        end
        event_cards_to_discard = player.event_cards_in_hand
      else
        event_cards_to_discard = []
      end
    end
    player_to_discard_in_hand(player) if player.toss_cards?
  end

  def display_player_cards_in_color(player)
    puts "These are your cards in hand : "
    player.names_of_player_cards_in_hand_based_color.each do |color|
      case color[0]
      when "red"
        print color[1..-1].to_s.red + ". "
      when "yellow"
        print color[1..-1].to_s.yellow + ". "
      when "blue"
        print color[1..-1].to_s.blue + ". "
      when "black"
        print color[1..-1].to_s.black.on_white + ". "
      end
    end
  end

  def player_to_discard_in_hand(player)

    display_player_cards_in_color(player)

    unless player.desc_of_event_cards_in_hand.empty?
      print player.desc_of_event_cards_in_hand.to_s
    end
    puts

    card_discarded = prompt_card_to_discard(player)
    discard_card_from_player_hand(player, card_discarded)
    puts card_discarded.cityname + " has been discarded to Player Discard Pile." if card_discarded.type == :player
    puts card_discarded.event.to_s + " has been discarded to Player Discard Pile." if card_discarded.type == :event
  end

  def which_event_card_to_use(player)
    event_satisfied = false
    while !event_satisfied
      print "Which event card to use? Type 'cancel' to cancel using event card. "
      event_string = gets.chomp
      if event_string.downcase == 'cancel'
        puts "Event use cancelled."
        puts
        return nil
      else
        event_card = string_to_players_player_card(event_string, player)
        if !event_card.nil? && player.event_cards_in_hand.include?(event_card)
          event_satisfied = true
        else
          puts "You don't have that event card or it's not an event card. Try again!"
        end
      end
    end
    return event_card
  end

  def prompt_card_to_discard(player)
    satisfied = false
    while !satisfied
      print "Pick a city or event name to discard card! "
      card_id_string = gets.chomp

      card = string_to_players_player_card(card_id_string, player)

      if card.nil?
        puts "That city name can't be found. Make sure capitalization is correct. For 'St Petersburg', no period is required after St"
      else
        satisfied = true
      end
    end
    return card
  end

  def epidemic_action
    #Update Infection Rate Index.
    @game.increase_infection_rate

    #Infect the bottom city in the Infection Deck with 3 cubes.
    dealt_cards = @game.infection_deck.shift(1)
    infection_card = dealt_cards[0]
    discard_card(@game.infection_discard_pile, infection_card)
    infection_card.reveal

    infected_city = string_to_city(infection_card.cityname)
    infected_city_original_color = infected_city.original_color
    puts "The revealed infection card is " + infection_card.cityname + " and its original color is " + infected_city_original_color.to_s
    puts

    perform_infect(infected_city, infected_city_original_color, 3)

    # Shuffle cards in the infection discard pile and put them on top of the Infection Deck.
    @game.infection_deck += @game.infection_discard_pile.shuffle!
    @game.infection_discard_pile = []
  end

  def perform_infect(city, color, number_of_cubes, setup = false)

    #No infection if disease is eradicated
    diseases = [@game.red_disease, @game.blue_disease, @game.black_disease, @game.yellow_disease]
    color_disease = diseases.select {|disease| disease.color == color}
    disease = color_disease[0]

    number_of_cubes = 0 if disease.eradicated


    #checking whether quarantine_specialist is in that city or neighboring cities.
    quarantine_specialist = symbol_to_player(:quarantine_specialist)

    neighboring_cities_pawns = []
    city.neighbors.each {|neighbor| neighboring_cities_pawns += neighbor.pawns}

    if setup || !quarantine_specialist.nil? ||  (!city.pawns.include?("☢") && !neighboring_cities_pawns.include?("☢"))
      existing_cubes = city.color_count
      if existing_cubes + number_of_cubes <= 3
        city.infect(color, number_of_cubes)
        reduce_color_cube_available(color, number_of_cubes)
        @game.end_game if @game.game_over?
      else
        if !@game.game_over?
          city.outbreak_happens
          neighbors_names = ""
          city.neighbors.each do |neighbor|
            if !neighbor.outbreak
              neighbors_names += neighbor.name + ". "
              perform_infect(neighbor, color, 1)
            end
          end
          puts "Outbreak on this city!".on_red + " Affected cities : "+ neighbors_names
          puts
          @game.increase_outbreak_index
        else
          @game.end_game
        end
      end
      @game.board.cities.each do |city|
        city.outbreak_reset
      end
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

  def print_card_in_color(card)
    if card.type == :event
      print card.event.to_s
    elsif card.type == :player || card.type == :infection
      case card.color
      when :red
        print card.cityname.red
      when :black
        print card.cityname.black.on_white
      when :yellow
        print card.cityname.yellow
      when :blue
        print card.cityname.blue
      end
    else
      print card.type.to_s
    end
  end

  def print_city_name_in_color(city)
    case city.original_color
    when :red
      print city.name.red
    when :black
      print city.name.black.on_white
    when :yellow
      print city.name.yellow
    when :blue
      print city.name.blue
    end
  end

  def print_city_cube_in_color(city)
    print city.red.to_s.red + ". " if city.red > 0
    print city.yellow.to_s.yellow + ". " if city.yellow > 0
    print city.blue.to_s.blue + ". " if city.blue > 0
    print city.black.to_s.black.on_white + ". " if city.black > 0
  end

end
