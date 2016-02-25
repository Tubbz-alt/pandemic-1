require_relative 'game'
require 'yaml'

class Pandemic

  def initialize
    setup
  end

  def setup
    print "Do you want to load a saved game? Type 'y' for confirmation! "
    if gets.chomp == "y"
      print "Please enter a yaml filename (without .yml extension)! "
      filename = gets.chomp
      @g = load_game_file(filename)
      puts "Game file #{filename}.yml has been loaded."
      @g.play
    else
      print "New file is created. The game will be autosaved. Please assign a new file name (without .yml extension)! "
      filename = gets.chomp
      puts "A pandemic game with filename #{filename}.yml has been created."
      @g = Game.new(filename)
    end
  end

  def load_game_file(filename)
    file = File.read("saved_games/#{filename}.yml")
    @g = YAML::load(file)
  end

end


if $PROGRAM_NAME == __FILE__
  p = Pandemic.new
end
