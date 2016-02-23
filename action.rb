# Action

require_relative 'mechanism'
require_relative 'communication'

class Action

  attr_reader :action_reduction, :player_location

  def initialize(turn)
    @turn = turn
    @player = @turn.player
    @game = @turn.game
    @mech = @game.mech
    @player_location = @mech.string_to_city(@player.location)
    @action_reduction = 0
  end

  def allowed_actions
    allowed_actions = {
    1 => "1. Drive/Ferry to neighboring town (1)",
    2 => "2. Direct Flight to a city by discarding the city card (1)",
    3 => "3. Charter Flight by discarding the city card you're currently in (1)",
    4 => "4. Shuttle flight from a research station to another (1)",
    5 => "5. Build a research station by discarding the city card you're in, or discarding city card is not necessary if player is operations expert (1). For building a research station through Government Grant event card, see number 12 below",
    6 => "6. Treat disease by removing 1 cube (or all cubes if player is medic) from city you're in. If disease is cured, remove all cubes of that color (1)",
    7 => "7. Share knowledge by giving the city card you're in with another player in your city, or if the player is researcher, the researcher can give a shared card that doesn't have to match the city both players are in (1)",
    8 => "8. Ask the researcher for any city card in Share Knowledge, as long as the player and the researched are in the same city (1)",
    9 => "9. Discover a cure by discarding 5 cards of the same color to cure disease of that color, or 4 cards only if the player is a scientist (1)",
    10 => "10. Take an event card from the Player Discard Pile if player is contingency player (1)",
    11 => "11. Use Resilient Population event by discarding the event card (0)",
    12 => "12. Use Government Grant event by discarding the event card (0)",
    13 => "13. Use Airlift event by discarding the event card (0)",
    14 => "14. Use One Quiet Night event by discarding the event card (0)",
    15 => "15. Use Forecast by discarding the event card (0)",
    16 => "16. Move from a research center to any city by discarding any city card once per turn if operations expert (1)",
    17 => "17. Communicate with the board to get game status. (0)"
    }
  end

  def filtered_actions
    actions = (1..17).to_a
  end

  def print_allowed_actions
    puts "Choose from the following possible actions (action worth):"
    allowed_actions.each do |k,v|
      puts v if filtered_actions.include?(k)
    end
    puts
  end

  def execute_player_action
    print "Enter action number : "
    action_number = gets.chomp.to_i
    case action_number
    when 1
      execution = drive(@player)
      execution ? @action_reduction = 1 : @action_reduction = 0
    when 2
      execution = direct_flight(@player)
      execution ? @action_reduction = 1 : @action_reduction = 0
    when 3
      execution = charter_flight(@player)
      execution ? @action_reduction = 1 : @action_reduction = 0
    when 4
      execution = shuttle_flight(@player)
      execution ? @action_reduction = 1 : @action_reduction = 0
    when 5
      execution = build_a_research_st(@player)
      execution ? @action_reduction = 1 : @action_reduction = 0
    when 6
      treat_disease(@player)
      @action_reduction = 1
    when 7
      execution = share_knowledge(@player)
      execution ? @action_reduction = 1 : @action_reduction = 0
    when 8
      if @player.role == :researcher
        puts "Researcher can't ask herself to give herself a card."
        puts
        return @action_reduction = 0
      else
        execution = ask_card_to_researcher(@player)
        execution ? @action_reduction = 1 : @action_reduction = 0
      end
    when 9
      execution = discover_cure(@player)
      execution ? @action_reduction = 1 : @action_reduction = 0
    when 10
      if @player.role == :contingency_planner
        if @player.event_card_on_role.size == 0
          execution = take_an_event_card_from_player_discard_pile(@player)
          execution ? @action_reduction = 1 : @action_reduction = 0
        end
      else
        puts "Action can't be completed. Either player's role is not Contingency Planner or it has more than 1 event card on his role card."
        puts
        @action_reduction = 0
      end
    when 11
      resilient_city(@player)
      @action_reduction = 0
    when 12
      build_a_research_st(@player, false)
      @action_reduction = 0
    when 13
      airlift(@player)
      @action_reduction = 0
    when 14

      @action_reduction = 0
    when 15
      forecast(@player)
      @action_reduction = 0
    when 16
      if !@player.role == :operations_expert
        puts "Player's role is not operations expert. Action cancelled."
        puts
        @action_reduction = 0
      elsif @turn.acts.include?(action_number)
        puts "This special action by operations expert can only be done once per turn. Action cancelled."
        puts
        @action_reduction = 0
      elsif !@player_location.research_st
        puts "Player is not in a city with research station. Action cancelled."
        puts
        @action_reduction = 0
      elsif @player.cards.size < 1
        puts "Player doesn't have a card to discard. Action cancelled."
        puts
        @action_reduction = 0
      else
        execution = operations_expert_move_to_any_city(@player)
        execution ? @action_reduction = 1 : @action_reduction = 0
      end
    when 17
      communicate_with_game
      @action_reduction = 0
    else
      puts "Invalid Entry! Try again!"
      @action_reduction = 0
    end
    return action_number
  end

  def medic_automatic_treat_cured(moved, city)
    if moved.role == :medic
      treat_disease(moved, :black) if @game.black_disease.cured
      treat_disease(moved, :blue) if @game.blue_disease.cured
      treat_disease(moved, :yellow) if @game.yellow_disease.cured
      treat_disease(moved, :red) if @game.red_disease.cured
    end
    # if @game.black_disease.cured || @game.blue_disease.cured || @game.yellow_disease.cured || @red_disease.cured
    #   puts "All cubes of cured diseases have been treated in this city by the medic without additional action."
    # end
    puts
  end

  def drive(player) #neighboring city movement
    satisfied = false
    while !satisfied

      moved = dispatcher_posibility(player)

      moved_current_city = @mech.string_to_city(moved.location)
      puts "Moved Player's current location is : " + moved.location

      neighbors = moved_current_city.neighbors

      puts "Neighbors of the moved player's current city : "
      neighbors.each do |neighbor|
        if neighbor.research_st
          research_st_indication = neighbor.research_st.to_s.upcase
        else
          research_st_indication = neighbor.research_st.to_s
        end
        puts neighbor.name.to_s + ". Players : "+ neighbor.pawns.to_s + ". Cubes : " + neighbor.color_count.to_s + ". Red, Yellow, Black, Blue : " + neighbor.red.to_s + ", "+ neighbor.yellow.to_s + ", "+ neighbor.black.to_s + ", "+ neighbor.blue.to_s + ". Research St : "+research_st_indication
      end

      print "Where to drive / ferry? Type 'cancel' to cancel this action. "
      destination_string = gets.chomp
      if destination_string == "cancel"
        executed = false
        puts "Action cancelled, no actions were used."
        puts
        return executed
      else
        destination = @mech.string_to_city(destination_string)

        if neighbors.include?(destination)
          satisfied = true
          @mech.move_player(player, destination_string, moved)
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
      print "Where to direct flight? Type 'cancel' to cancel this action. "
      destination_string = gets.chomp

      if destination_string == 'cancel'
        executed = false
          puts "Direct flight has been cancelled. No actions were used."
          puts
        return executed
      else
        destination_city = @mech.string_to_city(destination_string)
        destination_card = @mech.string_to_players_player_card(destination_string, player)

        moved = dispatcher_posibility(player)

        if !destination_card.nil?
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
        moved_satisfied = true if !moved.nil?
        puts "Incorrect player name. Try again." if moved.nil?
      end
    else
      moved = player
    end
    moved
  end

  def charter_flight(player) #discard city that matches the city you're in to move to any city.
    moved = dispatcher_posibility(player)

    charter_flight_card = @mech.string_to_players_player_card(moved.location, player)

    if charter_flight_card.nil?
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

          if !destination_city.nil?
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

    if player.role == :operations_expert
      use_card = false
      government_grant_card = @mech.string_to_players_player_card("Government_Grant", player)
      @mech.discard_card_from_player_hand(player, government_grant_card)
    end

    location_obtained = false
    while !location_obtained
      print "Where to put research center in? "
      location_string = gets.chomp
      location = @mech.string_to_city(location_string)
      location_obtained = true if !location.nil?
      puts "City unrecognized. Try again!" if location.nil?
    end

    location_card = @mech.string_to_players_player_card(location_string, player)

    if use_card
      if location_card.nil?
        puts "Player doesn't have that city player card! Builing research station cancelled."
        executed = false
      else
        puts "The city player card is used to build a research station and discarded to the Player Discard Pile"
        @mech.build_research_st(player, location)
        @mech.discard_card_from_player_hand(player, location_card)
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
        print "Which color do you want to treat? Type 'cancel' to cancel this action. "
        answer = gets.chomp

        if answer == 'cancel'
          executed = false
          puts "Treat disease has been cancelled."
          puts
          return executed
        else
          if answer.to_sym == :blue || answer.to_sym == :red || answer.to_sym == :yellow || answer.to_sym == :black
            color = answer.to_sym
            color_satisified = true
          else
            puts "Color unrecognized. All lowercase."
          end
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
    city_card = @mech.string_to_players_player_card(player.location, player)

    satisfied = false
    while !satisfied
      print "Whom to share knowledge with? Type 'cancel' to cancel this action. "
      answer = gets.chomp
      if answer == "cancel"
        executed = false
        puts "Action cancelled. No action was used."
        puts
        return executed
      else
        shared = @mech.string_to_player(answer)
        if !shared.nil? && city.pawns.include?(shared.pawn)
          satisfied = true
        else
          puts "Unrecognized player name or player not in the same city. Try again!"
        end
      end
    end

    card_satisfied = false
    while !card_satisfied
      if player.role == :researcher
        print "Which player city card to share? Type 'cancel' to cancel this action. "
        card_string = gets.chomp
        if card_string == "cancel"
          executed = false
          puts "Action cancelled. No action was used."
          puts
          return executed
        else
          city_card = @mech.string_to_players_player_card(card_string, player)
          if !city_card.nil?
            card_satisfied = true
            puts city_card.cityname + " is given to " + shared.name + " by " + player.name
            @mech.give_card_to_another_player(player, shared, city_card)
            puts
            executed = true
          else
            puts "Player doesn't have that card or Card name typed wrong. Try again!"
          end
        end
      elsif !city_card.nil?
        puts city_card.cityname + " is given to " + shared.name + " by " + player.name
        puts
        card_satisfied = true
        @mech.give_card_to_another_player(player, shared, city_card)
        executed = true
      else
        puts "Player is not a researcher and doesn't have the city player card both the player and the receiver are in. Action cancelled."
        card_satisfied = true
        executed = false
      end
    end
    return executed
  end

  def ask_card_to_researcher(player)
    city = @mech.string_to_city(player.location)
    sharer = @mech.symbol_to_player(:researcher)

    if !city.pawns.include?(sharer.pawn)
      executed = false
      puts "Researcher and player are not in the same city. Action cancelled. No action was used."
      puts
      return executed
    end

    card_satisfied = false
    while !card_satisfied
      puts "Which player city card to ask? Type 'cancel' to cancel this action"
      card_string = gets.chomp
      if card_string == "cancel"
        executed = false
        puts "Action cancelled. No action was used."
        puts
        return executed
      else
        city_card = @mech.string_to_player_card(card_string)
        if !city_card.nil? && sharer.cards.include?(city_card)
          card_satisfied = true
          puts city_card.cityname + " is given to " + player.name + " by " + sharer.name
          @mech.give_card_to_another_player(sharer, player, city_card)
          puts
          executed = true
        else
          puts "Researcher doesn't have that card or Card name typed wrong. Try again!"
        end
      end
    end
    return executed
  end

  def discover_cure(player)
    if player.role == :scientist
      req_no = 4
    else
      req_no = 5
    end

    player_city = @mech.string_to_city(player.location)

    if !player_city.research_st
      executed = false
      puts "Player is not in a research station. Action cancelled. No action was used."
      puts
      return executed
    end

    color_satisfied = false
    while !color_satisfied
      print "Which color to cure? Options are yellow, blue, black, red. Type 'cancel' to cancel action."
      color_string = gets.chomp

      if color_string == "cancel"
        executed = false
        puts "Action cancelled. No action was used."
        puts
        return executed
      else
        color = color_string.to_sym
        if color == :blue || color == :red || color == :black || color == :yellow
          color_satisfied = true
        else
          puts "Color unrecognized. Try again!"
        end
      end
    end

    cards_with_color = player.player_cards_in_hand.select {|card| card.color == color}

    if cards_with_color.size == req_no
      cards_with_color.each {|card| @mech.discard_card_from_player_hand(player, card)}
      puts "All cards with that color are discarded to the Player Discard Pile. Color cured."
      puts
      executed = true
    elsif cards_with_color.size < req_no
      executed = false
      puts "Color can't be cured because player has less than required city player cards with that color. Action cancelled."
      puts
      return executed
    else
      counter = 1
      while counter <= req_no
        player_card_confirmation = false
        while !player_card_confirmation
          puts "Choose from " + cards_with_color.to_s
          print "Type city name to discard one by one :"
          discard_city_string = gets.chomp
          discard_city_card = @mech.string_to_player_card(discard_city_string)
          if !discard_city_card.nil? && discard_city_card.color == color
            player_card_confirmation = true
            @mech.discard_card_from_player_hand(player, discard_city_card)
            puts discard_city_card.cityname + "is discarded to Player Discard Pile."
            cards_with_color.delete(discard_city_card)
          else
            puts "City unrecognized or its color is not the chosen to be cured. Try again!"
          end
        end
        counter += 1
      end
      executed = true
      puts color.to_s + " is cured."

      case color
      when :blue
        @game.blue_disease.cure
      when :red
        @game.red_disease.cure
      when :yellow
        @game.yellow_disease.cure
      when :black
        @game.black_disease.cure
      end
    end
    return executed
  end

  def take_an_event_card_from_player_discard_pile(player)
    satisfied = false
    while !satisfied
      puts "Event card available in the Player Discard Pile : "
      available_events = @game.player_discard_pile.select {|card| card.type == :event && card.deck == :player_discard_pile}
      puts available_events.to_s
      print "Choose an event to take from the Player Discard Pile. Type 'cancel' to cancel this action."
      chosen_string = gets.chomp
      if chosen_string == "cancel"
        executed = false
        puts "Action is cancelled. No action was used."
        puts
        return executed
      else
        chosen_card = @mech.string_to_player_card(chosen_string)
        if !chosen_card.nil?
          @mech.deal_known_card(@game.player_discard_pile, chosen_card)
          @mech.put_player_cards_into_hand([chosen_card], player)
          satisfied = true
          puts "That event card is taken from the Player Discard Pile onto your Role Card."
          puts
          executed = true
        else
          puts "That event is unrecognized. Please try again!"
        end
      end
    end
    return executed
  end

  def resilient_city(player)
    resilient_card = @mech.string_to_players_player_card("Resilient_Population",player)
    if !player.cards.include?(resilient_card)
      executed = false
      puts "Player doesn't have Resilient City Event Card. Event cancelled."
      return executed
    else
      satisfied = false
      while !satisfied
        puts "Which city name has Resilient Population? This city will have its infection card removed from the infection disard pile. Type 'cancel' to cancel."
        answer = gets.chomp
        if answer == "cancel"
          puts "Use of Resilient City cancelled."
          satisfied = true
        else
          city_card = @mech.string_to_infection_card(answer)
          if !city_card.nil?
            satisfied = true
            @mech.deal_known_card(@game.infection_discard_pile, city_card)
            city_card.discard_from_game
            @mech.discard_card_from_player_hand(player, resilient_card)
            puts city_card.cityname + " infection card has been removed from the Infection Discard Pile. Event card Resilient City has been discarded."
            puts
          else
            puts "That city name can't be found. Make sure capitalization is correct. For 'St Petersburg', no period is required after St, try again!"
          end
        end
      end
    end
  end

  def airlift(player)
    airlift_card = @mech.string_to_players_player_card("Airlift",player)

    if airlift_card.nil?
      executed = false
      puts "Player doesn't have the Airlift Event Card. Event cancelled."
      puts
      return executed
    end

    #Find the person who's moved.
    moved_confirmation = false
    while !moved_confirmation
      puts "You chose airlift event, which player's name do you wish to be airlifted? Type 'cancel' to cancel this event."
      moved_string = gets.chomp
      if moved_string == "cancel"
        executed = false
        puts "Airlift event cancelled."
        puts
        return executed
      else
        moved = @mech.string_to_player(moved_string)
        if !moved.nil?
          moved_confirmation = true
          puts moved.name + " is chosen."
        else
          puts "Please input the correct player's name. Try again!"
        end
      end
    end

    #Find where to move the moved person.
    destination_confirmation = false
    while !destination_confirmation
      puts "Where do you want to airlift " + moved.name + " to? Input city name! Type 'cancel' to cancel this event."
      destination_string = gets.chomp
      if destination_string == "cancel"
        executed = false
        puts "Airlift event cancelled."
        puts
        return executed
      else
        destination = @mech.string_to_city(destination_string)
        if !destination.nil?
          destination_confirmation = true
          @mech.move_player(player, destination.name, moved)
          moved.name + " is airlifted from " + moved.location + " to " + destination.name
          executed = true
        else
          puts "That city name can't be found. Make sure capitalization is correct. For 'St Petersburg', no period is required after St"
        end
      end
    end
    medic_automatic_treat_cured(moved, destination) if moved.role == :medic
    @mech.discard_card_from_player_hand(player, airlift_card)
    return executed
  end

  def forecast(player)

    forecast_card = @mech.string_to_players_player_card("Forecast",player)

    if !player.cards.include?(forecast_card)
      executed = false
      puts "Player doesn't have the Forecast Event Card. Event cancelled."
      puts
      return executed
    end

    top_6_infection_cards = @mech.deal_cards(@game.infection_deck, 6)
    puts "The 6 cards at the top of the infection deck is : "
    top_6_infection_cards.each_with_index do |card, idx|
      puts card.cityname + ", index = " + (idx+1).to_s
    end
    puts "The state of these cities are : "
    top_6_infection_cards.each do |card|
      city = @mech.string_to_city(card.cityname)
      print city.name + " : " + city.color_count.to_s + ". Neighbors : "
      neighbors_states = ""
      city.neighbors.each {|neighbor| neighbors_states += (neighbor.name + " : " + neighbor.color_count.to_s + ". ")}
      puts neighbors_states
      puts
    end
    new_6 = []
    inputed = []
    counter = 0
    puts "Rearrange these 6 cards by answering the following : "
    while counter <= 5
      idx_satisfied = false
      while !idx_satisfied
        print "Old index of new index + " + (counter+1).to_s + ", (1 refers to bottom of the 6) = "
        answer = gets.chomp.to_i
        if answer == 0
          puts "Not a valid integer (1-6)."
        elsif inputed.include?(answer)
          put "You have used that old index before. Choose another number!"
        else
          new_6 << top_6_infection_cards[answer-1]
          inputed << answer
          idx_satisfied = true
        end
      end
      counter += 1
    end
    @game.infection_deck += new_6
    @mech.discard_card_from_player_hand(player, forecast_card)
    puts "These 6 cards have been returned to the top of the infection deck. Their order, from the bottom of the deck, is :"
    new_6.each {|card| puts card.cityname}
    puts
  end

  def operations_expert_move_to_any_city(player)
    destination_confirmation = false
    while !destination_confirmation
      print "Which city you wish to go? Type 'cancel' to cancel this action. "
      destination_string = gets.chomp

      if destination_string == 'cancel'
        executed = false
        puts "Action cancelled. No action was used."
        puts
        return executed
      else
        destination = @mech.string_to_city(destination_string)
        if !destination.nil?
          destination_confirmation = true
        else
          puts "City unrecognized. Try again!"
        end
      end
    end

    discarded_card_confirmation = false
    while !discarded_card_confirmation
      print "Which city player card do you wish to discard? Type 'cancel' to cancel this action."
      card_string = gets.chomp

      if card_string == 'cancel'
        executed = false
        puts "Action cancelled. No action was used."
        puts
        return executed
      else
        card = @mech.string_to_card(card_string)
        if !card.nil? && player.cards.include?(card)
          discarded_card_confirmation = true
          executed = true
          moved = player
          @mech.move_player(player, destination.name, moved)
          @mech.discard_card_from_player_hand(player, card)
          puts player.name + " is moved to " + destination.name + " by discarding " + card.cityname + "Player Card."
          puts
        else
          puts "City Player Card unrecognized or player doesn't have that City Player Card. Try again!"
        end
      end
    end
    return executed
  end

  def communicate_with_game
    com = Communication.new(@game)
    end_communicate_with_game = false
    while !end_communicate_with_game
      print "Type 'ac' for available commands, to see commands that can be used to communicate with the game! "
      answer = gets.chomp
      puts
      if answer == 'ac'
        com.ac_triggered
      elsif answer == 'quit'
        end_communicate_with_game = true
      elsif !com.avail_commands_keys.include?(answer)
        puts "Invalid command."
      else
        com.execute_inquiry_command(answer)
      end
    end
  end

end
