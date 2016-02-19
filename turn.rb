# Turn
require_relative 'round'
require_relative 'action'

class Turn

  attr_reader :action_left, :acts

  def initialize(player, round)
    @player = player
    @round = round
    @game = @round.game
    @mech = @game.mech
    @location = @mech.string_to_city(player.location)
    @action_left = 4
    @acts = []
    actions
    # take_card_from_player_deck
    # infect
  end

  def reduce_action_left
    @action_left -= 1
  end

  def actions
    while @action_left > 0
      act = Action.new(self)
      puts "You have " + @action_left.to_s + " actions left."
      act.allowed_actions
      action_number = act.execute_player_action
      @acts << action_number if act.action_reduction == 1
      @action_left -= act.action_reduction
    end
  end

  def take_card_from_player_deck
    dealt_cards = @mech.deal_cards(@player, 2)
    @mech.put_player_cards_into_hand(dealt_cards, @player)
  end

  def infect
    number_of_infection_cards_taken = @game.infection_rate
    dealt_cards = @mech.deal_cards(@game.infection_deck, number_of_infection_cards_taken)

    dealt_cards.each do |card|
      infected_city = @mech.string_to_city(card.cityname)
      infected_city_original_color = infected_city.original_color

      @mech.perform_infect(infected_city, infected_city_original_color, 1)
      @mech.discard_card(@game.infection_discard_pile, card)
    end
  end


end
