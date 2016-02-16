# Mechanism

require_relative 'game'

class Mechanism

  attr_reader

  def initialize(game)
    @board = game.board
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



end
