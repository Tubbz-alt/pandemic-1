# Infection Card

class InfectionCard

  attr_reader :type, :cityname, :deck

  def initialize(cityname)
    @type = :infection
    @cityname = cityname
    @deck = :infection_deck
  end


end
