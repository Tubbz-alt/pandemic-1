# Action

require_relative 'mechanism.rb'

class Action

  attr_reader :action_reduction

  def initialize(player, game, player_location)
    @player = player
    @game = game
    @board = @board.board
    @player_location = player_location
    @mech = @game.mech
    @action_reduction = 0
  end

  def allowed_actions
    puts "Choose from the following possible actions (action worth):"
    puts "1. Drive/Ferry to neighboring town (1)"
    puts "2. Direct Flight to a city by discarding the city card (1)"
    puts "3. Charter Flight by discarding the city card you're currently in (1)"
    puts "4. Shuttle flight from a research station to another (1)"
    puts "5. Build a research station by discarding the city card you're in, or discarding city card is not necessary if player is operations expert (1)"
    puts "6. Treat disease by removing 1 cube (or all cubes if player is medic) from city you're in. If disease is cured, remove all cubes of that color (1)"
    puts "7. Share knowledge by giving the city card you're in with another player in your city, or if the player is researcher, the researched can give a shared card that doesn't have to match the city both players are in (1)"
    puts "8. Ask the researcher for a city card in Share Knowledge (1)"
    puts "9. Discover a cure by discarding 5 cards of the same color to cure disease of that color, or 4 cards only if the player is a scientist (1)"
    puts "10. Take an event card from the Player Discard Pile if player is contingency player (1)"
    puts "11. Use an event by discarding an event card (0)"
    puts "12. Move another's pawn to another city with that pawn if player is dispatcher (1)"
    puts "13. Move another's pawn as if it were the player's own if player is dispatcher(1)"
    puts "14. Move to any city by discarding any city card if operations expert (1)"
    puts
  end

  def get_player_action
    print "Enter action number : "
    action_number = gets.chomp.to_i
    case action_number
    when 1
      drive(@player)
      @action_reduction = 1
    when 2
      direct_flight(@player)
      @action_reduction = 1
    when 3
      charter_flight(@player)
      @action_reduction = 1
    when 4

    when 5

    when 6

    when 7

    when 8

    when 9

    when 10

    when 11

    when 12

    when 13

    when 14

    end
  end


  def drive(player) #neighboring city movement
    satisfied = false
    while !satisfied
      puts "Where to drive / ferry?"
      destination_string = gets.chomp

      moved = dispatcher_posibility(player)

      neighbors = @player_location.neighbors
      if neighbors.include?(@mech.string_to_city(destination_string))
        satisfied = true
        @mech.move_player(player, @mech.string_to_city(answer), moved)
        puts "Drove / Ferried to " + destination_string
      else
        puts "Neighbor city unrecognized."
      end
    end
  end

  def direct_flight(player) #discard a city card to move to city named on the card
    satisfied = false
    while !satisfied
      puts "Where to direct flight?"
      destination_string = gets.chomp
      destination_city = @mech.string_to_city(destination_string)
      destination_card = @mech.string_to_player_card(destination_string)

      moved = dispatcher_posibility(player)

      if player.cards.include?(destination_card)
        @mech.move_player(player, destination_string, moved)
        puts moved.name + " has been moved to " + destination_string
        @mech.discard_card_from_player_hand(player, destination_card)
        satisfied = true
      else
        puts "You don't have that player card with that city name. Try again."
      end
    end
  end

  def dispatcher_posibility(player)
    if player.role == :dispatcher
      moved_satisfied = false
      while !moved_satisfied
        puts "Whom to move? (own name or other player's name)"
        moved_string = gets.chomp
        moved = @mech.string_to_player(moved_string)
        moved_satisfied = true if moved != nil
        puts "Incorrect player name. Try again." if moved == nil
      end
    else
      moved = player
    end
  end

  def charter_flight(player) #discard city that matches the city you're in to move to any city.
    moved = dispatcher_posibility(player)

    charter_flight_card = @mech.string_to_player_card(moved.location)

    if !player.cards.include?(charter_flight_card)
      return "You can't do charter flight as you don't have the card with the moved player's current city name"
    else
      satisfied = false
      while !satisfied

      puts "Where to charter flight?"
      destination_string = gets.chomp
      destination_city = @mech.string_to_city(destination_string)

      if destination_city != nil
        @mech.move_player(player, destination_string, moved)
        puts moved.name + " has been moved to " + destination_string
        @mech.discard_card_from_player_hand(player, charter_flight_card)
        satisfied = true
      else
        puts "That's not a valid city destination. Try again."
      end
    end
  end

  def shuttle_flight(destination, from) #move from a research station to another research station

  end

  def build_a_research_st

  end


  def treat_disease

  end

  def share_knowledge

  end

  def discover_a_cure

  end

end
