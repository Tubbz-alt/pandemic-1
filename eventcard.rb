# Event Cards Class

class EventCard

  attr_reader :event, :description, :deck, :value

  def initialize(event, description)
    @event = event
    @description = description
    @deck = :player_deck
    @value = 1
  end

end
