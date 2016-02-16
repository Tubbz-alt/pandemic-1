# Turn
require_relative 'round'
require_relative 'action'

class Turn

  attr_reader :action_left

  def initialize(player, game)
    @player = player
    @cards = player.cards
    @role = player.role
    @game = game
    @board = @game.board
    @mech = @game.mech
    @location = @mech.string_to_city(player.location)
    @action_left = 4
    actions
    # take_card_from_player_deck
    # infect
  end

  def reduce_action_left
    @action_left -= 1
  end

  def actions
    while @action_left > 0
      act = Action.new(@player, @game, @location)
      puts "You have " + @action_left.to_s + " actions left."
      act.allowed_actions
      act.execute_player_action
      @action_left -= act.action_reduction
    end
  end

  def take_card_from_player_deck
    #draw 2 player cards
  end

  def infect
    #infect cities
  end


end
