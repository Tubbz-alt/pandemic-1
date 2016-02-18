# Player Class
require_relative 'game'

class Player

  attr_accessor :name, :role, :location, :cards, :pawn, :ability

  def initialize(name, role)
    @name = name
    @role = role
    @cards = []
    @location = "Atlanta"
  end

  def move_pawn(destination, moved = self)
    moved.location = destination.name
  end

  def cards_count
    count = 0
    @cards.each do |card|
      count += card.value
    end
    return count
  end

  def has_epidemic_card?
    epi = @cards.select {|card| card.type == :epidemic}
    return true if epi.size >= 1
    false
  end

  def toss_cards?
    cards_count > 7
    #unless it's event card that's taken by the contingency_planner
  end

  def put_cards_into_hand(cards)
    @cards += cards
  end

  def player_cards_in_hand
    player_cards = @cards.select {|card| card.type == :player}
  end

  def event_cards_in_hand
    event_cards = @cards.select {|card| card.type == :event}
  end

  def names_of_player_cards_in_hand
    player_cards_ih = player_cards_in_hand
    card_names = []
    player_cards_ih.each do |card|
      card_names << card.cityname
    end
    card_names
  end

  def desc_of_event_cards_in_hand
    event_cards_ih = event_cards_in_hand
    card_events = []
    event_cards_ih.each do |card|
      card_events << card.event.to_s
    end
    card_events
  end

  def discard_to_player_discard_pile(card)
    @cards.delete(card)
  end

  def discard_epidemic_card_to_discard_pile
    card = @cards.select {|card| card.type == :epidemic}
    card[0].discard_to_player_discard_pile
    discard_to_player_discard_pile(card[0])
  end

  def cards_in_hand_description
    show_array = []
    @cards.each do |card|
      if card.type == :player
        show_array << [card.cityname, card.value]
      elsif card.type == :event
        show_array << [card.event, card.value]
      end
    end
    return show_array
  end

  def highest_population
    max = 0
    self.player_cards_in_hand.each do |card|
      max < card.population ? max = card.population : max
    end
    return max
  end

end
