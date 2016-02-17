# Game
require_relative "board"
require_relative "player"
require_relative "epidemiccard"
require_relative "mechanism"

class Game

  attr_accessor :number_players, :infection_deck, :infection_discard_pile
  attr_reader :infection_rate_index, :players, :available_roles_to_pick, :deal_player_card_number, :epidemic_cards_number, :board, :outbreak_index, :blue_disease, :red_disease, :yellow_disease, :black_disease, :player_deck

  def initialize
    player_creation

    @infection_rate_index = 0
    @board = Board.new()
    @blue_disease = @board.blue_disease
    @red_disease = @board.red_disease
    @yellow_disease = @board.yellow_disease
    @black_disease  =@board.black_disease
    @infection_deck = setup_infection_deck #Index 0 = Bottom of deck
    @infection_discard_pile = []
    setup_player_deck #Returns @player_deck which index 0 = Bottom of deck

    @outbreak_index = 0

    @moderator = Player.new("game", :moderator)
    @mech = Mechanism.new(self)

    game_setup

  end

  def player_creation
    @players = []
    @available_roles_to_pick = ROLES.keys.shuffle
    @number_players = 0

    prompt_number_of_players

    @epidemic_cards_number = 0
    determine_epidemic_cards_number

    determine_deal_player_card_number
    create_players
    prompt_player_info

  end

  def game_setup
    move_all_pawns_to_Atlanta_in_setup
    deal_9_initial_infection_cards
    players_deal_initial_cards
    insert_epidemic_cards
    players_order_setup
    players_order
  end


  def prompt_number_of_players
    while @number_players < 2 or @number_players > 5 do
      print "Enter number of players (2 to 4)! "
      @number_players = gets.chomp.to_i
    end
    puts "There are "+@number_players.to_s+" players in this game"
    puts
  end

  def determine_epidemic_cards_number
    while @epidemic_cards_number == 0 do
      print "Pick difficulty level, 'i' for introductory, 's' for standard, or 'h' for heroic! "
      difficulty = gets.chomp.downcase

      case difficulty
      when "i"
        @epidemic_cards_number = 4
        difficulty_long = "introductory"
      when "s"
        @epidemic_cards_number = 5
        difficulty_long = "standard"
      when "h"
        @epidemic_cards_number = 6
        difficulty_long = "heroic"
      else
        puts "The only options are 'i', 's' or 'h'!"
      end

    end

    puts "This game's difficulty level is "+difficulty_long
    puts
  end

  def determine_deal_player_card_number
    case @number_players
    when 2
      @deal_player_card_number = 4
    when 3
      @deal_player_card_number = 3
    when 4
      @deal_player_card_number = 2
    end
  end

  def create_players
    @number_players.times do |player_number|
      player_number = Player.new("Player number " + (player_number+1).to_s, "roles")
      @players.push(player_number)
    end
  end

  def prompt_player_info
    @players.each_with_index do |player, idx|
      prompt_player_name(idx)
      puts
      prompt_player_role(idx)
      puts
    end
  end

  def prompt_player_name(idx)
    print "Enter Name of Player "+(idx + 1).to_s+"! "
    @players[idx].name = gets.chomp
    puts
  end

  def prompt_player_role(idx)
    puts "The available roles are "+@available_roles_to_pick.to_s
    print @players[idx].name.to_s+", please choose a number between 1 to "+@available_roles_to_pick.size.to_s+"! "
    chosen_role_index = gets.chomp.to_i
    @available_roles_to_pick.shuffle!
    @players[idx].role = @available_roles_to_pick[chosen_role_index-1]
    @players[idx].pawn = ROLES[@players[idx].role][0]
    @players[idx].ability = ROLES[@players[idx].role][1]
    @available_roles_to_pick.delete(@players[idx].role)
    puts @players[idx].name.to_s+", your role is "+@players[idx].role.to_s
    puts "Your pawn symbol is " + @players[idx].pawn
    puts "Your special ability is " + @players[idx].ability
    puts
  end

  def game_over?
    if win?
      true
    elsif lose?
      true
    else
      false
    end
  end

  def win?
    if @blue_disease.cured == true && @red_disease.cured == true && @yellow_disease.cured == true && @black_disease.cured == true
      return true
    end
    false
  end

  def lose_on_max_outbreaks?
    if @outbreak_index < MAX_OUTBREAKS
      return false
    else
      return true
    end
  end

  def lose_on_cubes_availability?
    if @blue_disease.cubes_available == 0
      puts "No more blue cubes! Game over!"
      puts
      return true
    elsif @red_disease.cubes_available == 0
      puts "No more red cubes! Game over!"
      puts
      return true
    elsif @yellow_disease.cubes_available == 0
      puts "No more yellow cubes! Game over!"
      puts
      return true
    elsif @black_disease.cubes_available == 0
      puts "No more black cubes! Game over!"
      puts
      return true
    end
    false
  end

  def move_all_pawns_to_Atlanta_in_setup
    @players.each do |player|
      @mech.move_player(@moderator, "Atlanta", player)
    end
  end

  def lose_on_player_cards_availability?
    @player_deck.size == 0
  end

  def lose?
    if lose_on_max_outbreaks?
      puts "Lose on Max Outbreaks! Game over!"
      puts
      return true
    elsif lose_on_cubes_availability?
      return true
    elsif lose_on_player_cards_availability?
      puts "You run out of Player Cards! Game Over!"
      puts
      return true
    end
    false
  end

  def increase_outbreak_index
    @outbreak_index += 1
  end

  def infection_rate #CommandLine
    INFECTION_RATE_BOARD[@infection_rate_index]
  end

  def increase_infection_rate
    if @infection_rate_index != INFECTION_RATE_BOARD.size - 1
      @infection_rate_index += 1
    end
  end

  def setup_infection_deck
    @board.infection_cards.shuffle!
  end

  def setup_player_deck
    @player_deck = @board.player_cards.shuffle!
  end

  def insert_epidemic_cards
    case @epidemic_cards_number
    when 4
      first_pile_cards = @player_deck[0..10]
      second_pile_cards = @player_deck[11..21]
      third_pile_cards = @player_deck[22..32]
      fourth_pile_cards = @player_deck[33..-1]

      first_pile_cards << EpidemicCard.new
      second_pile_cards << EpidemicCard.new
      third_pile_cards << EpidemicCard.new
      fourth_pile_cards << EpidemicCard.new

      @player_deck =  first_pile_cards.shuffle! + second_pile_cards.shuffle! + third_pile_cards.shuffle! + fourth_pile_cards.shuffle!

    when 5
      first_pile_cards = @player_deck[0..8]
      second_pile_cards = @player_deck[9..18]
      third_pile_cards = @player_deck[19..27]
      fourth_pile_cards = @player_deck[28..37]
      fifth_pile_cards = @player_deck[38..-1]

      first_pile_cards << EpidemicCard.new
      second_pile_cards << EpidemicCard.new
      third_pile_cards << EpidemicCard.new
      fourth_pile_cards << EpidemicCard.new
      fifth_pile_cards << EpidemicCard.new

      @player_deck =  first_pile_cards.shuffle! + second_pile_cards.shuffle! + third_pile_cards.shuffle! + fourth_pile_cards.shuffle! + fifth_pile_cards.shuffle!

    when 6
      first_pile_cards = @player_deck[0..6]
      second_pile_cards = @player_deck[7..13]
      third_pile_cards = @player_deck[14..21]
      fourth_pile_cards = @player_deck[22..29]
      fifth_pile_cards = @player_deck[30..37]
      sixth_pile_cards = @player_deck[38..-1]

      first_pile_cards << EpidemicCard.new
      second_pile_cards << EpidemicCard.new
      third_pile_cards << EpidemicCard.new
      fourth_pile_cards << EpidemicCard.new
      fifth_pile_cards << EpidemicCard.new
      sixth_pile_cards << EpidemicCard.new

      @player_deck =  first_pile_cards.shuffle! + second_pile_cards.shuffle! + third_pile_cards.shuffle! + fourth_pile_cards.shuffle! + fifth_pile_cards.shuffle! + sixth_pile_cards.shuffle!
    end
  end

  def deal_9_initial_infection_cards
    # First 3 cards contain cities which will be infected with 3 cubes of their original colors. Second 3 cards contain cities with 2 cubes. Third 3 cards contain cities with 1 cube.
    3.times do |number|
      city_cards = deal_card(@infection_deck, 3)
      city_cards.each do |card|
        perform_action(card, (3 - number))
      end
    end
  end

  def deal_card(from, number_of_cards = 1)
    from.pop(number_of_cards)
  end

  def perform_action(card, number_of_infection = 1, player = @players[0])
    if card.type == :infection
      affected_city = @board.cities.select {|city| city.name == card.cityname}
      perform_infect(affected_city[0], affected_city[0].original_color, number_of_infection)
      @board.cities.each do |city|
        city.outbreak_reset
      end
      @infection_discard_pile << card
    elsif card.type == :player
      # build a research_center (action available -= 1), or move_pawns (action available -= 1), or transfer cards (action available -=1).
    elsif card.type == :event
      perform_event_cards(card, player)
      @mech.discard_to_player_discard_pile(player, card)
    elsif card.type == :epidemic
      # puts Epidemic action
    end
  end

  def perform_event_cards(card, player)
    case card.event
    when :Resilient_Population
      discarded_city = prompt_for_which_resilient_city
      discarded_city.remove_from_game
      @infection_discard_pile.delete(discarded_city)
      puts discarded_city.cityname + " infection card is removed from the infection discard pile (and the game)."
    when :Government_Grant
      #Is addressed as Action option #12.
    when :Airlift
      airlifted_player = prompt_whom_to_be_airlifted
      destination = prompt_where_to_airlift(airlifted_player)
      current_city = determine_current_city(airlifted_player)
      current_city.pawn_move_from_city(airlifted_player)
      destination.pawn_move_to_city(airlifted_player)
      player.move_pawn(destination, airlifted_player)
    when :One_Quiet_Night
      perform_one_quiet_night(player)
    when :Forecast
      confirmation = false
      while !confirmation
        puts "Would you like to use forecast? 'y' or 'n'"
        answer = gets.chomp
        if answer == 'y'
          confirmation = true
          perform_forecast
        elsif answer =='n'
          return "Forecast cancelled"
          confirmation = true
        else
          puts "Only answer 'y' or 'n'"
        end
      end
    end
  end

  def perform_forecast
    top_6_infection_cards = deal_card(@infection_deck, 6)
    puts "The 6 cards at the top of the infection deck is : "
    top_6_infection_cards.each_with_index do |card, idx|
      puts card.cityname + ", index = " + (idx+1).to_s
    end
    puts "The state of these cities are : "
    top_6_infection_cards.each do |card|
      city = city_forecast(card)
      print city.name + " : " + city.color_count.to_s + ". Neighbors : "
      neighbors_states = ""
      city.neighbors.each {|neighbor| neighbors_states += (neighbor.name + " : " + neighbor.color_count.to_s + ". ")}
      puts neighbors_states
      puts
    end
    new_6 = []
    puts "Rearrange these 6 cards by answering the following :"
    print "Old index of new index 1 (bottom of 6), insert previous 1 through 6 = "
    new0 = gets.chomp.to_i
    new_6 << top_6_infection_cards[new0-1]
    print "Old index of new index 2, insert prev 1 through 6 = "
    new1 = gets.chomp.to_i
    new_6 << top_6_infection_cards[new1-1]
    print "Old index of new index 3, insert prev 1 through 6 = "
    new2 = gets.chomp.to_i
    new_6 << top_6_infection_cards[new2-1]
    print "Old index of new index 4, insert prev 1 through 6 = "
    new3 = gets.chomp.to_i
    new_6 << top_6_infection_cards[new3-1]
    print "Old index of new index 5, insert prev 1 through 6 = "
    new4 = gets.chomp.to_i
    new_6 << top_6_infection_cards[new4-1]
    print "Old index of new index 6 (top of 6), insert prev 1 through 6 = "
    new5 = gets.chomp.to_i
    new_6 << top_6_infection_cards[new5-1]
    @infection_deck += new_6
    puts "These 6 cards have been returned to the top of the infection deck. Their order, from the bottom of the deck, is :"
    new_6.each {|card| puts card.cityname}
  end

  def city_forecast(card)
    city = @board.cities.select {|city| city.name == card.cityname}
    city[0]
  end

  def determine_current_city(player)
    city_string = player.location
    current_city = @board.cities.select {|city| city.name == city_string}
    current_city[0]
  end

  def prompt_where_to_airlift(airlifted_player)
    confirmation = false
    while !confirmation
      puts "Where do you want to airlift " + airlifted_player.name + " to? Input city name!"
      answer = gets.chomp
      destination = @board.cities.select {|city| city.name == answer}
      if destination.size != 0
        confirmation = true
        airlifted_player.name + " is airlifted from " + airlifted_player.location + " to " + destination[0].name
      else
        puts "That city name can't be found. Make sure capitalization is correct. For 'St Petersburg', no period is required after St"
      end
    end
    destination[0]
  end

  def prompt_whom_to_be_airlifted
    confirmation = false
    while !confirmation
      puts "You chose airlift event, which player's name do you wish to be airlifted?"
      answer = gets.chomp
      airlifted_player = @players.select {|player| player.name == answer}
      if airlifted_player.size != 0
        confirmation = true
        puts airlifted_player[0].name + " is chosen."
      else
        puts "Please input the correct player's name. Use g.players to get a list of players info"
      end
    end
    airlifted_player[0]
  end


  def prompt_for_which_resilient_city
    satisfied = false
    while !satisfied
      puts "Which city name has Resilient Population? This city will have its infection card removed from the infection disard pile."
      answer = gets.chomp
      selected_city = @infection_discard_pile.select {|card| card.cityname == answer}
      satisfied = true if selected_city.size != 0
      puts "That city name can't be found. Make sure capitalization is correct. For 'St Petersburg', no period is required after St" if selected_city.size == 0
    end
    return selected_city[0]
  end

  def put_player_cards_into_hand(dealt_cards, player)
    player.put_cards_into_hand(dealt_cards)
    if player.has_epidemic_card?
      puts "You got an epidemic card!"
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
    @mech.discard_to_player_discard_pile(player, card_discarded)
    puts card_discarded.cityname + " has been discarded to Player Discard Pile." if card_discarded.type == :player
    puts card_discarded.event + " has been discarded to Player Discard Pile." if card_discarded.type == :event
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

  def perform_infect(city, color, number_of_cubes)
    existing_cubes = city.color_count
    if existing_cubes + number_of_cubes <= 3
      city.infect(color, number_of_cubes)
      reduce_color_cube_available(color, number_of_cubes)
      if lose?
        game_over?
      end
    else
      if !lose?
        city.outbreak_happens = true
        neighbors_names = ""
        city.neighbors.each do |neighbor|
          if !neighbor.outbreak
            neighbors_names + " " + neighbor.name
            perform_infect(neighbor, color, 1)
          end
        end
        puts "Outbreak on this city! Affected cities : "+neighbors_names
        increase_outbreak_index
      else
        game_over?
      end
    end
  end

  def reduce_color_cube_available(color, number = 1)
    case color
    when :red
      @red_disease.reduce_cubes_available(number)
    when :yellow
      @yellow_disease.reduce_cubes_available(number)
    when :black
      @black_disease.reduce_cubes_available(number)
    when :blue
      @blue_disease.reduce_cubes_available(number)
    end
  end

  def players_deal_initial_cards
    @players.each do |player|
      cards_dealt = deal_card(@player_deck, @deal_player_card_number)
      put_player_cards_into_hand(cards_dealt, player)
    end
  end

  def players_order_setup
    population_ordered_by_player_no = []
    @players.each do |player|
      population_ordered_by_player_no << player.highest_population
    end
    sorted = population_ordered_by_player_no.sort {|a,b| b<=>a}
    new_players_order_array = []
    sorted.each do |population|
      @players.each do |player|
        new_players_order_array << player if player.highest_population == population
      end
    end
    @players = new_players_order_array
  end



  INFECTION_RATE_BOARD = [2,2,2,3,3,4,4]

  MAX_OUTBREAKS = 8

  ROLES = {
    contingency_planner: ["♲", "The contingency planner may, as an action, take an Event card from anywhere in the Player Discard Pile and place it on his Role Card. Only 1 Event Card can be on his role card at a time. It does not count against his hand limit. When the Contingency Planner plays the Event card on his role card, remove this Event card from the game (instead of discarding it)."],
    dispatcher: ["✈", "The dispatcher may, as an action, either : move any pawn, if its owner agrees, to any city containing another pawn, or move another player's pawn, if its owner agrees, as if it were his own. When moving a player's pawn as if it were your own, discard cards for Direct and Charter Flights from your hand. A card discarded for a Charter Flight must match the city the pawn is moving from."],
    medic: ["⛑", "The medic removes all cubes, not 1, of the same color when doing the Treat Disease action. If a disease has been cured, he automatically removes all cubes of that color from a city, simply by entering it or being there. This does not take an action. The medic's automatic removal of cubes can occur on other players' turns, if he is moved by the dispatcher or the airlift event."],
    operations_expert: ["☖","The operations expert may, as an action, either: build a research station in his current city without discarding (or using) a city card, or, once per turn, move from a research station to any city by discarding any city card. The dispatcher may not use the operation expert's special move ability when moving the operation expert's pawn."],
    quarantine_specialist: ["☢", "The quarantine specialist prevents both outbreaks and the placement of disease cubes in the city she is in and all cities connected to that city. She does not affect cubes placed during setup."],
    researcher: ["⚭","When doing the share knowledge action, the researcher may give any city from her hand to another player in the same city as her, without this card having to match her city. The transfer must be from her hand to the other player's hand, but it can occur on either player's turn."],
    scientist: ["⚗", "The scientist needs only 4 (not 5) city cards of the same disease color to discover a cure for that disease."]
  }

  def players_order #CommandLine
    names = @players.collect {|player| player.name}
    puts "The player order based on highest population on each hand (first means first turn or player 1): " + names.to_s
  end

  def player(number) #CommandLine
    return @players[number-1]
  end

  def show_cities(number_of_infection = 0)#CommandLine
    if number_of_infection == 0
      number_array = (1..3).to_a
      cities = []
      result = []
      number_array.each do |number|
        cities += @board.cities.select {|city| city.color_count == number}
      end
      cities.each do |city|
        result << [city.name.to_s + " : " + city.color_count.to_s]
      end
      return result
    else
      if number_of_infection < 0 || number_of_infection > 3
        puts "Only input 1, 2 or 3, or no numbers at all"
      else
        cities = @board.cities.select {|city| city.color_count == number_of_infection}
        cities.collect {|city| city.name}
      end
    end
  end

  def research_st_cities #CommandLine
    @board.research_st_cities
  end

end
