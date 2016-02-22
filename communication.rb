# # Communication
# This page provides dictionary of possible user commands to get information on the state of the game.
require_relative 'game'

class Communication

  attr_reader :commands

  def initialize(game)
    @game = game
    @commands = commands
  end

  def ac_triggered
    @commands.keys.each do |key|
      puts key + " : "+ @commands[key][0]
    end
  end

  def execute_inquiry_command(string)
    puts @commands[string][1].call
    puts
  end


  def commands
    {
    "ac" => ["to show available commands"],
    "quit" => ["to end communication with the board"],
    "players_order" => ["to show the order of all players(who goes first, etc)", @game.players_order],
    "player(1)" => ["to show details of player 1.", @game.player(1)],
    "player(2)" => ["to show details of player 2.", @game.player(2)],
    # "player(3)" => ["to show details of player 3.", @game.player(3)],
    # "player(4)" => ["to show details of player 4.", @game.player(4)],
    }
  end

end
