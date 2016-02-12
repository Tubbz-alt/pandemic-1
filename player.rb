# Player Class
require_relative 'game'

class Player

  attr_accessor :name, :role, :location, :cards, :pawn, :ability

  def initialize(name, role)
    @name = name
    @role = role
    @cards = []
    # @location = CityObject
  end

  def move_pawn(player = self, destination)

  end



end
