# Game
require_relative "board"
require_relative "player"
require_relative "epidemiccard"
require_relative "mechanism"
require_relative "round"
require_relative "communication"

class Game

  attr_accessor :number_players, :infection_deck, :infection_discard_pile, :player_discard_pile, :rounds
  attr_reader :infection_rate_index, :players, :available_roles_to_pick, :deal_player_card_number, :epidemic_cards_number, :board, :outbreak_index, :blue_disease, :red_disease, :yellow_disease, :black_disease, :player_deck, :infection_rate, :game_run, :rounds, :mech

  def initialize
    player_creation

    @infection_rate_index = 0
    @infection_rate = INFECTION_RATE_BOARD[@infection_rate_index]
    @board = Board.new()
    @blue_disease = @board.blue_disease
    @red_disease = @board.red_disease
    @yellow_disease = @board.yellow_disease
    @black_disease  =@board.black_disease
    @infection_deck = setup_infection_deck #Index 0 = Bottom of deck
    @infection_discard_pile = []
    @player_discard_pile = []
    setup_player_deck #Returns @player_deck which index 0 = Bottom of deck

    @outbreak_index = 0

    @moderator = Player.new("game", :moderator)
    @mech = Mechanism.new(self)

    @game_run = true
    game_setup
    @mech.players = @players

    welcome_players

    @rounds = []
    game_start

  end

# Game Starter

  def welcome_players
    puts
    puts
    puts "Board is set. Let's start the game!!"
    puts
    puts
  end

  def game_start
    while @game_run
      round = Round.new(self)
    end
  end


# The following are the game checker / ender

  def end_game
    @game_run = false
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
      puts "You won!!"
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

# The following are game simple mechanism

  def increase_outbreak_index
    @outbreak_index += 1
  end

  def increase_infection_rate
    if @infection_rate_index != INFECTION_RATE_BOARD.size - 1
      @infection_rate_index += 1
    end
    @infection_rate = INFECTION_RATE_BOARD[@infection_rate_index]
  end

# The following section includes setting up board.

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
    build_research_st_in_Atlanta
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

  def move_all_pawns_to_Atlanta_in_setup
    @players.each do |player|
      @mech.move_player(@moderator, "Atlanta", player)
    end
  end

  def build_research_st_in_Atlanta
    @mech.build_research_st(@moderator, @board.atlanta)
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
      city_cards = @mech.deal_cards(@infection_deck, 3)
      city_cards.each do |card|
        perform_initial_infection(card, (3 - number))
        @mech.discard_card(@infection_discard_pile, card)
      end
    end
  end

  def perform_initial_infection(card, number)
    if card.type == :infection
      infected_city = @mech.string_to_city(card.cityname)
      infected_city_original_color = infected_city.original_color
      @mech.perform_infect(infected_city, infected_city_original_color, number, true)
    else
      puts "Error, this should be handled in different parts of the game. You've found a bug!"
    end
  end

  def players_deal_initial_cards
    @players.each do |player|
      cards_dealt = @mech.deal_cards(@player_deck, @deal_player_card_number)
      @mech.put_player_cards_into_hand(cards_dealt, player)
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

  def players_order
    names = @players.collect {|player| player.name}
    puts "The player order based on highest population on each hand (first means first turn or player 1): " + names.to_s
  end

end
