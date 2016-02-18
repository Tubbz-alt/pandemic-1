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
    puts "5. Build a research station by discarding the city card you're in, or discarding city card is not necessary if player is operations expert (1). For building a research station through Government Grant event card, see number 12 below"
    puts "6. Treat disease by removing 1 cube (or all cubes if player is medic) from city you're in. If disease is cured, remove all cubes of that color (1)"
    puts "7. Share knowledge by giving the city card you're in with another player in your city, or if the player is researcher, the researcher can give a shared card that doesn't have to match the city both players are in (1)"
    puts "8. Ask the researcher for a city card in Share Knowledge (1)"
    puts "9. Discover a cure by discarding 5 cards of the same color to cure disease of that color, or 4 cards only if the player is a scientist (1)"
    puts "10. Take an event card from the Player Discard Pile if player is contingency player (1)"
    puts "11. Use Resilient Population event by discarding the event card (0)"
    puts "12. Use Government Grant event by discarding the event card (0)"
    puts "13. Use Airlift event by discarding the event card (0)"
    puts "14. Use One Quiet Night event by discarding the event card (0)"
    puts "15. Use Forecast by discarding the event card (0)"
    puts "16. As a contingency planner, take an event card from the Player Discard Pile (1)"
    puts "17. Move to any city by discarding any city card if operations expert (1)"
    puts
  end

  def execute_player_action
    print "Enter action number : "
    action_number = gets.chomp.to_i
    case action_number
    when 1
      execution = drive(@player)
      execution? @action_reduction = 1 | @action_reduction = 0
    when 2
      direct_flight(@player)
      execution? @action_reduction = 1 | @action_reduction = 0
    when 3
      charter_flight(@player)
      execution? @action_reduction = 1 | @action_reduction = 0
    when 4
      shuttle_flight(@player)
      execution? @action_reduction = 1 | @action_reduction = 0
    when 5
      execution = build_a_research_st(@player)
      execution? @action_reduction = 1 | @action_reduction = 0
    when 6
      treat_disease(@player)
      @action_reduction = 1
    when 7
      execution = share_knowledge(@player)
      execution? @action_reduction = 1 | @action_reduction = 0
    when 8

    when 9

    when 10

    when 11

    when 12
      build_a_research_st(@player, false)
      @action_reduction = 0
    when 13

    when 14

    when 15

    when 16

    when 17

    end
  end

  def medic_automatic_treat_cured(player, city)
    if player.role == :medic
      treat_disease(moved, :black)
      treat_disease(moved, :blue)
      treat_disease(moved, :yellow)
      treat_disease(moved, :red)
    end
    puts "All cubes of cured diseases have been treated in this city by the medic without additional action."
    puts
  end

  def drive(player) #neighboring city movement
    satisfied = false
    while !satisfied
      print "Where to drive / ferry? Type 'cancel' to cancel this action."
      destination_string = gets.chomp
      if destination_string == "cancel"
        executed = false
        puts "Action cancelled, no actions were used."
        puts
        return executed
      else
        destination = @mech.string_to_city(destination_string)
        moved = dispatcher_posibility(player)

        neighbors = @player_location.neighbors
        if neighbors.include?(destination)
          satisfied = true
          @mech.move_player(player, @mech.string_to_city(answer), moved)
          puts "Drove / Ferried to " + destination_string
          executed = true
        else
          puts "Neighbor city unrecognized."
        end
      end
    end

    medic_automatic_treat_cured(moved, destination) if moved.role == :medic
    return executed
  end

  def direct_flight(player) #discard a city card to move to city named on the card
    satisfied = false
    while !satisfied
      puts "Where to direct flight? Type 'cancel' to cancel this action."
      destination_string = gets.chomp

      if destination_string == 'cancel'
        executed = false
          puts "Direct flight has been cancelled. No actions were used."
          puts
        return executed
      else
        destination_city = @mech.string_to_city(destination_string)
        destination_card = @mech.string_to_player_card(destination_string)

        moved = dispatcher_posibility(player)

        if player.cards.include?(destination_card)
          @mech.move_player(player, destination_string, moved)
          puts moved.name + " has been moved to " + destination_string
          @mech.discard_card_from_player_hand(player, destination_card)
          satisfied = true
          executed = true
        else
          puts "You don't have that player card with that city name. Try again."
        end
      end
    end
    medic_automatic_treat_cured(moved, destination_city) if moved.role == :medic
    return executed
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
      executed = false
      puts "You can't do charter flight as you don't have the card with the moved player's current city name. Charter flight is cancelled. No action were used."
      puts
      return executed
    else
      satisfied = false
      while !satisfied
        puts "Where to charter flight? Type 'cancel' to cancel this action."
        destination_string = gets.chomp

        if destination_string == 'cancel'
          executed = false
          puts "Charter flight is cancelled. No action were used."
          puts
          return executed
        else
          destination_city = @mech.string_to_city(destination_string)

          if destination_city != nil
            @mech.move_player(player, destination_string, moved)
            puts moved.name + " has been moved to " + destination_string
            @mech.discard_card_from_player_hand(player, charter_flight_card)
            satisfied = true
            executed = true
          else
            puts "That's not a valid city destination. Try again."
          end
        end
      end
      return executed
    end

    medic_automatic_treat_cured(moved, destination_city) if moved.role == :medic
    return executed
  end

  def shuttle_flight(player) #move from a research station to another research station
    moved = dispatcher_posibility(player)

    if !@player_location.research_st
      executed = false
      puts "Moved player is not in a city with a research station! Action is cancelled. No action was used".
      puts
      return executed
    end

    satisfied = false
    while !satisfied
      puts "Where to shuttle flight? Type 'cancel' to cancel this action."
      destination_string = gets.chomp

      if destination_string == "cancel"
        executed = false
        puts "Action is cancelled. No action was used".
        puts
        return executed
      else
        destination_city = @mech.string_to_city(destination_string)

        if destination_city.research_st
          @mech.move_player(player, destination_string, moved)
          puts moved.name + " has been moved to " + destination_string
          satisfied = true
          executed = true
        else
          puts "That's not a valid destination. Try again."
        end
      end
    end
    medic_automatic_treat_cured(moved, destination_city) if moved.role == :medic
    return executed
  end

  def build_a_research_st(player, use_card = true)

    location_obtained = false
    while !location_obtained
      print "Where to put research center in?"
      location_string = gets.chomp
      location = @mech.string_to_city(location_string)
      location_obtained = true if location != nil
      puts "City unrecognized. Try again!" if location == nil
    end

    use_card = false if player.role == :operations_expert

    if use_card
      if !player.cards.include?(location)
        puts "Player doesn't have that city player card! Builing research station cancelled."
        executed = false
      else
        puts "The city player card is used to build a research station and discarded to the Player Discard Pile"
        @mech.build_research_st(player, location)
        player_card_to_discard = @mech.string_to_player_card(location.string)
        @mech.discard_card_from_player_hand(player, player_card_to_discard)
        executed = true
      end
    else
      @mech.build_research_st(player, location)
      puts "A research station has been added to that city."
      executed = true
    end
    return executed
  end

  def treat_disease(player, color = :no_color, number = 1)

    city = @mech.string_to_city(player.location)

    if color == :no_color
      color_satisified = false
      while !color_satisified
        puts city.name + " has the the following cubes (red, black, blue, yellow) : " + city.red.to_s + ", " + city.black.to_s + ", " + city.blue.to_s + ", " + city.yellow.to_s
        puts "Which color do you want to treat?"
        answer = gets.chomp.to_sym
        if answer == :blue || answer == :red || answer == :yellow || answer == :black
          color = answer
          color_satisified = true
        else
          puts "Color unrecognized. All lowercase."
        end
      end
    end

    case color
    when :black
      var_in_game_class = @game.black_disease
    when :blue
      var_in_game_class = @game.blue_disease
    when :yellow
      var_in_game_class = @game.yellow_disease
    when :red
      var_in_game_class = @game.red_disease
    end

    if var_in_game_class.cured
      @mech.treat(player, city, color, var_in_game_class, true)
    else
      @mech.treat(player, city, color, var_in_game_class, false, number)
    end
  end

  def share_knowledge(player)
    city = @mech.string_to_city(player.location)
    city_card = @mech.string_to_player_card(player.location)

    satisfied = false
    while !satisfied
      print "Whom to share knowledge with?"
      answer = gets.chomp
      shared = @mech.string_to_player(answer)
      if shared != nil && city.pawns.include?(shared.pawn)
        satisfied = true
      else
        puts "Unrecognized player name or player not in the same city."
      end
    end

    card_satisfied = false
    while !card_satisfied
      if player.role == :researcher
        puts "Which player city card to share?"
        card_string = gets.chomp
        city_card = @mech.string_to_player_card(card_string)
        if card != nil && player.cards.include?(card)
          card_satisfied = true
          puts city_card.cityname + " is given to " + shared.name + " by " + player.name
          @mech.give_card_to_another_player(player, shared, city_card)
          puts
          executed = true
        else
          puts "Player doesn't have that card or Card name typed wrong. Try again!"
        end
      elsif player.cards.include?(city_card)
        puts city_card.cityname + " is given to " + shared.name + " by " + player.name
        puts
        satisfied = true
        @mech.give_card_to_another_player(player, shared, city_card)
        executed = true
      else
        puts "Player is not a medic and doesn't have the city player card both the player and the receiver are in. Action cancelled."
        executed = false
      end
    end
    return executed
  end

  def discover_a_cure

  end

end
