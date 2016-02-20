# # Communication
# This page provides dictionary of possible user commands to get information on the state of the game.
require_relative 'game'

class Communication

  def initialize(game)
    @game = game
    @players_order = @game.players_order
  end

  def ac_triggered
    #Available Commands are inquired by player.
    availablecommands.each do |key|
      puts key + " : "+ COMMANDS[key][0]
    end
  end

  def availablecommands
    COMMANDS.keys
  end

  def execute_inquiry_command(string)
    COMMANDS[string][1]
  end

  COMMANDS = {
    "ac" => ["to show available commands"],
    "quit" => ["to end communication with the board"],
    "players_order" => ["to show the players order (who goes first, etc)", @players_order],
    # "player(1)" => ["to show details of player 1", @game.player(1)],
    # "player(2)" => ["to show details of player 2", @game.player(2)],
    # "player(3)" => ["to show details of player 2", @game.player(3)],
    # "player(4)" => ["to show details of player 2", @game.player(4)],
    # "players" => ["to show details of all players.", @game.players]
  }

end
