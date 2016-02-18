# Event Cards Class

class EventCard

  attr_reader :event, :description, :deck, :value, :type

  def initialize(event, description)
    @type = :event
    @event = event
    @description = description
    @deck = :player_deck
    @value = 1
  end

  def taken_by_a_player(player)
    initial_deck = @deck

    if player.role == :contingency_planner && initial_deck == :player_discard_pile
      @value = 0
    end

    @deck = player.name.to_sym
  end

  def discard_to_player_discard_pile
    @deck = :player_discard_pile
  end

  def discard_from_game
    @deck = :not_in_game
  end

end
