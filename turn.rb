# Turn
require_relative 'round'
require_relative 'action'

class Turn

  attr_reader :action_left, :acts, :player, :game, :one_quiet_night

  def initialize(player, round)
    @player = player
    @round = round
    @game = @round.game
    @mech = @game.mech
    @location = @mech.string_to_city(player.location)
    @action_left = 4
    @acts = Array.new(4)
    @one_quiet_night = false
  end

  def play_turn
    actions if @game.game_run
    take_card_from_player_deck if @game.game_run
    infect if @game.game_run && !@one_quiet_night
  end

  def reduce_action_left
    @action_left -= 1
  end

  def one_quiet_night_mode
    @one_quiet_night = true
  end

  def actions
    while @action_left > 0
      act = Action.new(self)
      puts @player.name.underline + "'s turn. You have ".underline + @action_left.to_s.underline + " actions left.".underline
      act.print_allowed_actions
      action_number = act.execute_player_action
      @acts[@action_left-4] = action_number if act.action_reduction == 1
      if @game.game_over?
        @game.end_game
        break
      end
      @action_left -= act.action_reduction
      puts
      save_game_file(@game.filename)
    end
  end

  def take_card_from_player_deck
    dealt_cards = @mech.deal_cards(@game.player_deck, 2)
    puts "The following cards are taken from the Player Deck to " + @player.name + "'s hands : " + card_description(dealt_cards).to_s
    puts
    @mech.put_player_cards_into_hand(dealt_cards, @player)
  end

  def infect
    number_of_infection_cards_taken = @game.infection_rate
    dealt_cards = @mech.deal_cards(@game.infection_deck, number_of_infection_cards_taken)
    puts "The following cards are taken from the Infection Deck : " + card_description(dealt_cards).to_s
    puts

    dealt_cards.each do |card|
      infected_city = @mech.string_to_city(card.cityname)
      infected_city_original_color = infected_city.original_color

      @mech.perform_infect(infected_city, infected_city_original_color, 1)
      @mech.discard_card(@game.infection_discard_pile, card)
    end
  end

  def card_description(cards_array)
    event_cards = cards_array.select {|card| card.type == :event}
    epidemic_cards = cards_array.select {|card| card.type == :epidemic}
    city_cards = cards_array.select {|card| card.type == :player}
    infection_cards = cards_array.select {|card| card.type == :infection}

    event_desc = event_cards.collect {|card| card.event}
    epidemic_desc = epidemic_cards.collect {|card| card.type}
    city_desc = city_cards.collect {|card| card.cityname}
    infection_desc = infection_cards.collect {|card| card.cityname}

    array = []
    array += event_desc + epidemic_desc + city_desc + infection_desc
    return array.compact
  end

  def save_game_file(filename)
    File.open("saved_games/#{filename}.yml","w"){|file| file.write(@game.to_yaml)}
  end

  def mid_turn?
    @action_left != 0
  end

end
