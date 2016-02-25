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

  def mid_round?
    @turns.compact.size != @players.size
  end

  def complete_current_round
    index_of_last_completed_player = @turns.compact.size - 1
    index_of_next_player = index_of_last_completed_player+1
    players_yet_to_play = @players[index_of_next_player..-1]

    play_remaning_of_round(players_yet_to_play, index_of_last_completed_player+1)

  end

  def play_remaning_of_round(players, index_of_prev_player)
    players.each_with_index do |player, idx|
      @turns[idx + index_of_prev_player] = Turn.new(player, self)
      @turns[idx + index_of_prev_player].play_turn
    end
  end

end
