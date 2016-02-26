# Infection Card

class InfectionCard

  attr_reader :type, :cityname, :deck, :color

  def initialize(cityname, color)
    @type = :infection
    @cityname = cityname
    @deck = :infection_deck
    @color = color
  end

  def reveal
    @deck = :infection_discard_pile
  end

  def remove_from_game
    @deck = :not_in_game
  end

end
