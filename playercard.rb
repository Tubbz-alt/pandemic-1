# Player Card

class PlayerCard

  attr_accessor :type, :cityname, :deck, :population, :value

  def initialize(cityname, color, population)
    @type = :player
    @cityname = cityname
    @deck = :player_deck
    @value = 1
    @population = population
  end

  def taken_by_a_player(player)
    @deck = player.name.to_sym
  end

  def discard_to_player_discard_pile
    @deck = :player_discard_pile
  end

end
