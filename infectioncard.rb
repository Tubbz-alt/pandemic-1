# Infection Card

class InfectionCard

  attr_reader :type, :cityname, :deck

  def initialize(cityname)
    @type = :infection
    @cityname = cityname
    @deck = :infection_deck
  end

  def reveal
    @deck = :infection_discard_pile
  end

end
