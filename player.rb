# Player Class
require_relative 'game'

class Player

  attr_accessor :name, :role, :city, :cards

  def initialize(name, role)
    @name = name
    @role = role
    @cards
    # @city = CityObject
  end

  def move_pawn(player = self, destination)

  end



end
