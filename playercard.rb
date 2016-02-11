# Player Card

class PlayerCard

  attr_accessor :type, :cityname, :deck

  def initialize(cityname, color)
    @type = :player
    @cityname = cityname
    @deck = :player_deck
  end

  def reveal
    if @deck == :player_deck
      # @deck = player's hand
      # Add to the Player_Discard_Pile
      return @cityname
    else
      raise "City card is not in the Player Deck"
    end
  end

end
