# City Card

class CityCard

  attr_accessor :type, :cityname, :deck

  def initialize(cityname, color)
    @type = :city
    @cityname = cityname
    @deck = :player_deck
  end

  def reveal
    if @deck == :player_deck
      @deck = :player_discard_pile
      # Add to the Player_Discard_Pile
      return @cityname
    else
      raise "City card is already in Player Discard Pile"
    end
  end

end
