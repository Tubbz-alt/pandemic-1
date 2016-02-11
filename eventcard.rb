# Event Cards Class

class EventCard

  attr_reader :event, :description, :deck

  def initialize(event, description)
    @event = event
    @description = description
    @deck = :player_deck
  end

end
