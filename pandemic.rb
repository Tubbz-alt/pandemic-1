require_relative 'game'
require 'yaml'
require 'fileutils'

class Pandemic

  def initialize
    load_banner
    setup
  end

  def setup
    print "Do you want to load a saved game? Type 'y' for confirmation! "
    if gets.chomp.downcase == "y"
      if saved_games_folder?
        list_files = all_yml_files_in_saved_games
        if list_files.size > 0
          puts "Available filenames = " + list_files.to_s
          print "Please enter a game filename! "
          filename = gets.chomp
          if list_files.include?(filename)
            @g = load_game_file(filename)
            puts "Game file #{filename} has been loaded."
            puts
            return @g.play
          else
            puts "Game file not found."
          end
        end
      else
        puts "No saved games so far!"
      end
    end

    print "New file will be created. The game will be autosaved. Please assign a new file name! "
    filename = gets.chomp
    puts
    @g = Game.new(filename)

  end

  def load_game_file(filename)
    file = File.read("saved_games/#{filename}.yml")
    @g = YAML::load(file)
  end

  def saved_games_folder?
    File.exist?('saved_games')
  end

  def all_yml_files_in_saved_games
    files = Dir.glob("saved_games/*.yml")
    file_names = files.collect {|file| file[12..-5]}
  end

  def load_banner
    puts "
 #####     ##    #    #  #####   ######  #    #  #   ####
 #    #   #  #   ##   #  #    #  #       ##  ##  #  #    #
 #    #  #    #  # #  #  #    #  #####   # ## #  #  #
 #####   ######  #  # #  #    #  #       #    #  #  #
 #       #    #  #   ##  #    #  #       #    #  #  #    #
 #       #    #  #    #  #####   ######  #    #  #   ####
                                                           ".red
    puts
  end


end


if $PROGRAM_NAME == __FILE__
  p = Pandemic.new
end
