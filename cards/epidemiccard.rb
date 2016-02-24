# Epidemic Card

class EpidemicCard

  attr_reader :type, :deck

  def initialize
    @type = :epidemic
    @deck = :player_deck
  end

  def taken_by_a_player(player)
    @deck = player.name.to_sym
  end

  def discard_to_player_discard_pile
    @deck = :player_discard_pile
  end

end
