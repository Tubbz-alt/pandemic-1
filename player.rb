# Player Class

require 'colorize'

class Player

  attr_accessor :name, :role, :location, :cards, :pawn, :ability

  def initialize(name, role)
    @name = name
    @role = role
    @cards = []
    @location = "Atlanta"
  end

  def move_pawn(destination, moved)
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

  def names_of_player_cards_in_hand_based_color
    player_cards_ih = player_cards_in_hand
    red_cards = []
    black_cards = []
    blue_cards = []
    yellow_cards = []

    player_cards_ih.each do |card|
      red_cards << card.cityname if card.color == :red
      black_cards << card.cityname if card.color == :black
      blue_cards << card.cityname if card.color == :blue
      yellow_cards << card.cityname if card.color == :yellow
    end
    cards = [["Red", red_cards], ["Black", black_cards], ["Blue", blue_cards], ["Yellow", yellow_cards]]

    nested_cards = cards.select {|color| !color[1].empty?}
    flattened_cards = nested_cards.collect {|color| color.flatten}
    flattened_cards
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

  def discard_from_game(card)
    @cards.delete(card)
  end

  def discard_epidemic_card_to_discard_pile
    card = @cards.select {|card| card.type == :epidemic}
    card[0].discard_to_player_discard_pile
    discard_to_player_discard_pile(card[0])
    return card[0]
  end

  def highest_population
    max = 0
    self.player_cards_in_hand.each do |card|
      max < card.population ? max = card.population : max
    end
    return max
  end

  def event_card_on_role_card
    if @role == :contingency_planner
      event_cards_ih = event_cards_in_hand
      event_card_on_role = event_cards_ih.select {|card| card.value == 0}
      return event_card_on_role
    end
    puts "Only contingency planner has event card on his role card."
  end

end
