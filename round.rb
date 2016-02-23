# Round
require_relative "turn"
require_relative "game"

class Round

  attr_reader :players, :game
  attr_accessor :turns

  def initialize(game)
    @game = game
    @players = @game.players
    @turns = []
    new_turn
  end

  def new_turn
    @players.each do |player|
      @turns << Turn.new(player, self)
    end
    end_round
  end

  def end_round
    @game.rounds << self
  end

end
