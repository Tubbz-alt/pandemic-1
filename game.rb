# Game
require_relative "board"
require_relative "player"

class Game

  attr_accessor :number_players, :difficulty, :infection_deck, :infection_discard_pile
  attr_reader :infection_rate_index, :players

  def initialize(number_players, difficulty)
    @number_players = number_players
    @infection_rate_index = 0
    @board = Board.new()
    @infection_deck = setup_infection_deck #Index 0 = Bottom of deck
    @infection_discard_pile = []
    @players = []

    # case difficulty
    # when "introductory":
    #   @difficulty = "4 Epidemic Cards"
    # when "standard"
    #   @difficulty = "5 Epidemic Cards"
    # when "heroic"
    #   @difficulty = "6 Epidemic Cards"
    # else
    #   raise "Acceptable inputs are only 'introductory', 'standard', or 'heroic'!"
    # end
    create_players
  end


  def create_players
    @number_players.times do |player_number|
      player_number = Player.new("Player number " + (player_number+1).to_s, "roles")
      @players.push(player_number)
    end
  end


  def infection_rate
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
