# Game
require_relative "board"
require_relative "player"

class Game

  attr_accessor :number_players, :infection_deck, :infection_discard_pile
  attr_reader :infection_rate_index, :players, :available_roles_to_pick, :deal_player_card_number, :epidemic_cards_number, :board, :outbreak_index, :blue_disease, :red_disease, :yellow_disease, :black_disease

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
    # @player_deck = setup_player_deck #Index 0 = Bottom of deck
    @players = []
    @available_roles_to_pick = ROLES.keys.shuffle
    @outbreak_index = 0
    create_players
    prompt_player_info
    determine_deal_player_card_number
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
      when "s"
        @epidemic_cards_number = 5
      when "h"
        @epidemic_cards_number = 6
      else
        puts "The only options are 'i', 's' or 'h'!"
      end

    end

    puts "This game's difficulty level is "+difficulty.to_s
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
    @available_roles_to_pick.delete(@players[idx].role)
    puts @players[idx].name.to_s+", your role is "+@players[idx].role.to_s
    puts
  end


  def players_info #API
    @players.each_with_index do |player, idx|
      puts "Player "+(idx+1).to_s+" = "+player.name.to_s+", role = "+player.role.to_s
    end
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
    # return all diseases cured
  end


  def lose_on_max_outbreaks?
    if @outbreak_index < MAX_OUTBREAKS
      return false
    else
      return true
    end
  end

  def lose?
    if lose_on_max_outbreaks?
      puts "Lose on Max Outbreaks! Game over!"
      return true
    end
    false
  end

  def increase_outbreak_index
    @outbreak_index += 1
  end

  def infection_rate #API
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

  # def setup_player_deck
  #   @board.player_cards.shuffle!
  #
  #
  # end
  #
  # def divide_player_cards_by_epidemic_cards_number
  #   case @epidemic_cards_number
  #   when 4
  #     first_pile_cards_number = @board.player_cards.size / 4
  #
  # end


  def deal_card(from, number_of_cards = 1)
    from.pop(number_of_cards)
    perform_actions(from)
  end

  def perform_action(from)
    if from == @infection_deck
    # Actions
    # Discard card
    elsif from == @player_deck
    # Actions
    # Discard card
    end
  end


  def perform_infect


  end






  INFECTION_RATE_BOARD = [2,2,2,3,3,4,4]

  MAX_OUTBREAKS = 8

  ROLES = {
    contingency_planner: [:ct, "The contingency planner may, as an action, take an Event card from anywhere in the Player Discard Pile and place it on his Role Card. Only 1 Event Card can be on his role card at a time. It does not count against his hand limit. When the Contingency Planner plays the Event card on his role card, remove this Event card from the game (instead of discarding it)."],
    dispatcher: [:d, "The dispatcher may, as an action, either : move any pawn, if its owner agrees, to any city containing another pawn, or move another player's pawn, if its owner agrees, as if it were his own. When moving a player's pawn as if it were your own, discard cards for Direct and Charter Flights from your hand. A card discarded for a Charter Flight must match the city the pawn is moving from."],
    medic: [:m, "The medic removes all cubes, not 1, of the same color when doing the Treat Disease action. If a disease has been cured, he automatically removes all cubes of that color from a city, simply by entering it or being there. This does not take an action. The medic's automatic removal of cubes can occur on other players' turns, if he is moved by the dispatcher or the airlift event."],
    operations_expert: [:oe,"The operations expert may, as an action, either: build a research station in his current city without discarding (or using) a city card, or, once per turn, move from a research station to any city by discarding any city card. The dispatcher may not use the operation expert's special move ability when moving the operation expert's pawn."],
    quarantine_specialist: [:qs, "The quarantine specialist prevents both outbreaks and the placement of disease cubes in the city she is in and all cities connected to that city. She does not affect cubes placed during setup."],
    researcher: [:r,"When doing the share knowledge action, the researcher may give any city from her hand to another player in the same city as her, without this card having to match her city. The transfer must be from her hand to the other player's hand, but it can occur on either player's turn."],
    scientist: [:s, "The scientist needs only 4 (not 5) city cards of the same disease color to discover a cure for that disease."]
  }

end
