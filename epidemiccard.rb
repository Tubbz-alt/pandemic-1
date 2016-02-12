# Epidemic Card

class EpidemicCard

  attr_reader :type, :deck

  def initialize
    @type = :epidemic
    @deck = :player_deck
  end
end
