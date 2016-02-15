# Event Cards Class

class EventCard

  attr_reader :event, :description, :deck, :value, :type

  def initialize(event, description)
    @type = :event
    @event = event
    @description = description
    @deck = :player_deck
    @value = 1
  end

  def taken_by_a_player(player)
    @deck = player.name.to_sym
  end

  def discard_to_player_discard_pile
    @deck = :player_discard_pile
  end

  def taken_by_cont_planner_from_player_disc_pile(player_name_in_string)
    @deck = player_name_in_string.to_sym
    @value = 0
  end

  def perform(event, player, city_research_center = 0, airlifted_player = 0)
    case event
    when :Resilient_Population
      perform_resilient_population(player, city)
    when :Government_Grant
      perform_government_grant(player, city_research_center)
    when :Airlift
      perform_airlift(player, airlifted_player, city)
    when :One_Quiet_Night
      perform_one_quiet_night(player)
    when :Forecast
      perform_forecast(player)
    end
  end


  def perform_resilient_population(player, city)

  end

  def perform_government_grant(player, city)

  end

  def perform_airlift(performer_player, airlifted_player, city)
    performer_player.move_pawn(airlifted_player, city)

  end

  def perform_one_quiet_night(player)

  end

  def perform_forecast(player)


  end


end
