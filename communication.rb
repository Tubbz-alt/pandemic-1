# # Communication
# This page provides dictionary of possible user commands to get information on the state of the game.
require_relative 'game'
require 'colorize'

class Communication

  attr_reader :commands

  def initialize(game)
    @game = game
  end

  def ac_triggered
    COMMANDS.keys.each do |key|
      puts key + " : "+ COMMANDS[key]
    end
    puts
  end

  def execute_inquiry_command(string)
    if string == "players_order" || string == "infection_rate" || string == "outbreak_index" || string == "show_cities" || string == "players" || string == "research_st_cities" || string == "city_info" || string == "disease"
      send string.to_sym
    elsif string == "black_disease"
      print_disease_status(@game.black_disease)
    elsif string =="red_disease"
      print_disease_status(@game.red_disease)
    elsif string =="yellow_disease"
      print_disease_status(@game.yellow_disease)
    elsif string =="blue_disease"
      print_disease_status(@game.blue_disease)
    elsif string =="show_cities(1)" || string == "show_cities(2)" || string == "show_cities(3)"
      send string[0..10].to_sym, string[12].to_i
    end
    puts
  end

  def avail_commands_keys
    COMMANDS.keys + ["show_cities(2)", "show_cities(3)"]
  end

  COMMANDS =
    {
    "ac" => "to show available commands",
    "quit" => "to end communication with the board",
    "players_order" => "to show the order of all players(who goes first, etc)",
    "players" => "to show details of all players",
    "infection_rate" => "to show the current infection rate.",
    "outbreak_index" => "to show the current outbreak index.",
    "disease" => "to show the status of all diseases.",
    "show_cities" => "to show cities with any cubes.",
    "show_cities(1)" => "to show cities with 1 cube. Other available commands are 'show_cities(2)' and 'show_cities(3)'",
    "research_st_cities" => "to show cities with research stations.",
    "city_info" => "to show information of a city"
    }

  # The following are made as communication means from the command line during game.

  def players_order
    names = @game.players.collect {|player| player.name}
    puts "The player order based on highest population on each hand (first means first turn or player 1): " + names.to_s
  end

  def players
    @game.players.each_with_index do |player, idx|
      puts "Player " + (idx+1).to_s
      puts player.name + " is a " + player.role.to_s + ". "+ player.ability

      print "City Cards : "
      player.names_of_player_cards_in_hand_based_color.each do |color|
        case color[0]
        when "Red"
          print "Red : ".red + color[1..-1].to_s.red + ". "
        when "Yellow"
          print "Yellow : ".yellow + color[1..-1].to_s.yellow + ". "
        when "Blue"
          print "Blue : ".blue + color[1..-1].to_s.blue + ". "
        when "Black"
          print "Black : ".black.on_white + color[1..-1].to_s.black.on_white + ". "
        end
      end
      puts

      unless player.desc_of_event_cards_in_hand.empty?
        puts "Event Cards : " + player.desc_of_event_cards_in_hand.to_s
      end

      puts "Location : " + player.location
      puts
    end
  end

  def disease
    diseases = [["Red",@game.red_disease], ["Blue",@game.blue_disease], ["Yellow",@game.yellow_disease], ["Black",@game.black_disease]]
    diseases.each do |disease|
      print disease[0].red if disease[0] == "Red"
      print disease[0].blue if disease[0] == "Blue"
      print disease[0].yellow if disease[0] == "Yellow"
      print disease[0].black.on_white if disease[0] == "Black"
      puts ". Cubes available : " + disease[1].cubes_available.to_s + ". Cured : " + disease[1].cured.to_s + ". Eradicated : " + disease[1].eradicated.to_s
    end
  end

  def infection_rate
    puts "Infection Rate : " + @game.infection_rate.to_s
  end

  def outbreak_index
    puts "Outbreak Index : " + @game.outbreak_index.to_s
  end

  def show_cities(number_of_infection = 0)
    if number_of_infection == 0
      number_array = (1..3).to_a
      cities = []
      result = []
      number_array.each do |number|
        cities += @game.board.cities.select {|city| city.color_count == number}
      end
      cities.each do |city|
        result << [city.name.to_s + " : " + city.color_count.to_s]
      end
      puts result
    else
      if number_of_infection < 0 || number_of_infection > 3
        puts "Only input 1, 2 or 3, or no numbers at all."
      else
        cities = @game.board.cities.select {|city| city.color_count == number_of_infection}
        city_names = cities.collect {|city| city.name}
        puts "Cities with " + number_of_infection.to_s + " cubes are : " + city_names.to_s
      end
    end
  end

  def research_st_cities
    puts "Cities with research station are : " + @game.board.research_st_cities.to_s
  end

  def city_info
    satisfied = false
    while !satisfied
      print "Which city would you like to get information of? Type 'cancel' to cancel this action. "
      answer_string = gets.chomp

      if answer_string == 'cancel'
        return
      else
        city = @game.mech.string_to_city(answer_string)
        if city.nil?
          puts "City unrecognized. Try again!"
        else
          if city.research_st
            research_st_indication = city.research_st.to_s.upcase
          else
            research_st_indication = city.research_st.to_s
          end

          puts "Players : "+city.pawns.to_s+". Cubes : "+city.color_count.to_s+". Red, Yellow, Black, Blue : " + city.red.to_s.red + ", "+ city.yellow.to_s.yellow + ", "+ city.black.to_s.black.on_white + ", "+ city.blue.to_s.blue + ". Research St : "+ research_st_indication

          puts "Neighbors : "
          city.neighbors.each do |neighbor|
            if neighbor.research_st
              research_st_indication = neighbor.research_st.to_s.upcase
            else
              research_st_indication = neighbor.research_st.to_s
            end
            puts neighbor.name.to_s + ". Players : "+ neighbor.pawns.to_s + ". Cubes : " + neighbor.color_count.to_s + ". Red, Yellow, Black, Blue : " + neighbor.red.to_s.red + ", "+ neighbor.yellow.to_s.yellow + ", "+ neighbor.black.to_s.black.on_white + ", "+ neighbor.blue.to_s.blue + ". Research St : "+research_st_indication
          end

          satisfied = true
        end
      end
    end
    puts

  end

end
