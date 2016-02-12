# Player Class
require_relative 'game'

class Player

  attr_accessor :name, :role, :location, :cards, :pawn, :ability

  def initialize(name, role)
    @name = name
    @role = role
    @cards = []
    @location = "Atlanta"
  end

  def move_pawn(player = self, destination)
    @location = destination.name
  end

  def cards_count
    @cards.size
  end

  def toss_cards?
    cards_count == 7
    #unless it's event card that's taken by the contingency_planner
  end

  def reveal_player_deck

  end

end
