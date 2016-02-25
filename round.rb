# Round
require_relative "turn"
require_relative "game"

class Round

  attr_reader :players, :game
  attr_accessor :turns

  def initialize(game)
    @game = game
    @players = @game.players
    @turns = Array.new(@players.size)
  end

  def new_round
    @players.each_with_index do |player, idx|
      @turns[idx] = Turn.new(player, self)
      @turns[idx].play_turn
    end
  end

end
