# Game
require_relative "board"
require_relative "player"
require_relative "epidemiccard"

class Game

  attr_accessor :number_players, :infection_deck, :infection_discard_pile
  attr_reader :infection_rate_index, :players, :available_roles_to_pick, :deal_player_card_number, :epidemic_cards_number, :board, :outbreak_index, :blue_disease, :red_disease, :yellow_disease, :black_disease, :player_deck

  def initialize
    @number_players = 0
    prompt_number_of_players

    @epidemic_cards_number = 0
    determine_epidemic_cards_number

    @infection_rate_index = 0
    @board = Board.new()
    @blue_disease = @board.blue_disease
    @red_disease = @board.red_disease
    @yellow_disease = @board.yellow_disease
    @black_disease  =@board.black_disease
    @infection_deck = setup_infection_deck #Index 0 = Bottom of deck
    @infection_discard_pile = []
    setup_player_deck #Returns @player_deck which index 0 = Bottom of deck
    @players = []
    @available_roles_to_pick = ROLES.keys.shuffle
    @outbreak_index = 0
    create_players
    prompt_player_info
    determine_deal_player_card_number
    move_all_pawns_to_Atlanta_in_setup

    deal_9_initial_infection_cards

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
      @board.atlanta.pawn_move_to_city(player)
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
    else
      raise "Infection Rate is already maxed"
    end
  end

  def setup_infection_deck
    @board.infection_cards.shuffle!
  end

  def setup_player_deck
    insert_epidemic_cards
  end

  def insert_epidemic_cards
    @board.player_cards.shuffle!
    case @epidemic_cards_number
    when 4
      first_pile_cards = @board.player_cards[0..12]
      second_pile_cards = @board.player_cards[13..25]
      third_pile_cards = @board.player_cards[26..38]
      fourth_pile_cards = @board.player_cards[39..-1]

      first_pile_cards << EpidemicCard.new
      second_pile_cards << EpidemicCard.new
      third_pile_cards << EpidemicCard.new
      fourth_pile_cards << EpidemicCard.new

      @player_deck =  first_pile_cards.shuffle! + second_pile_cards.shuffle! + third_pile_cards.shuffle! + fourth_pile_cards.shuffle!

    when 5
      first_pile_cards = @board.player_cards[0..10]
      second_pile_cards = @board.player_cards[11..20]
      third_pile_cards = @board.player_cards[21..31]
      fourth_pile_cards = @board.player_cards[32..42]
      fifth_pile_cards = @board.player_cards[43..-1]

      first_pile_cards << EpidemicCard.new
      second_pile_cards << EpidemicCard.new
      third_pile_cards << EpidemicCard.new
      fourth_pile_cards << EpidemicCard.new
      fifth_pile_cards << EpidemicCard.new

      @player_deck =  first_pile_cards.shuffle! + second_pile_cards.shuffle! + third_pile_cards.shuffle! + fourth_pile_cards.shuffle! + fifth_pile_cards.shuffle!

    when 6
      first_pile_cards = @board.player_cards[0..8]
      second_pile_cards = @board.player_cards[9..17]
      third_pile_cards = @board.player_cards[18..26]
      fourth_pile_cards = @board.player_cards[27..36]
      fifth_pile_cards = @board.player_cards[37..44]
      sixth_pile_cards = @board.player_cards[45..-1]

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

  def perform_action(card, number_of_infection = 1)
    affected_city = @board.cities.select {|city| city.name == card.cityname}
    if card.type == :infection
      perform_infect(affected_city[0], affected_city[0].original_color, number_of_infection)
      @board.cities.each do |city|
        city.outbreak_reset
      end
      @infection_discard_pile << card
    else
      @deal_player_card_number.times do |card_number|
        taken_card = @player_deck.pop
        if taken_card.type == :player || taken_card.type = :event
          #Player gets to keep that card
          #Check max number of card in hand = 7
        elsif taken_card.type == :epidemic
          puts "Epidemic Card"
        end
        puts "Player Card size = "+@player_deck.size.to_s
      end
    end
  end


  def perform_infect(city, color, number_of_cubes)
    existing_cubes = city.color_count
    if existing_cubes + number_of_cubes <= 3
      city.infect(color, number_of_cubes)
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

  def player(number) #CommandLine
    return @players[number-1]
  end

  def show_cities(number_of_infection) #CommandLine
    cities = @board.cities.select {|city| city.color_count == number_of_infection}
    cities.collect {|city| city.name}
  end

end
