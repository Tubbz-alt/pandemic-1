# Board
require_relative "city"
require_relative "cards/infectioncard"
require_relative "cards/playercard"
require_relative "cards/eventcard"
require_relative "disease"

class Board

  attr_reader :cities, :infection_cards, :player_cards, :algiers, :atlanta, :baghdad, :bangkok, :beijing, :bogota, :buenosaires, :cairo, :chennai, :chicago, :delhi, :essen, :hochiminh, :istanbul, :jakarta, :johannesburg, :hongkong, :karachi, :khartoum, :kinshasa, :kolkata, :lagos, :lima, :london, :losangeles, :manila, :madrid, :mexicocity, :miami, :milan, :montreal, :moscow, :mumbai, :newyork, :osaka, :paris, :riyadh, :sanfrancisco, :santiago, :saopaulo, :seoul, :shanghai, :stpetersburg, :sydney, :taipei, :tehran, :tokyo, :washington, :red_disease, :black_disease, :yellow_disease, :blue_disease, :research_station_available, :research_station_built

  def initialize

    build_cities

    @cities = [@algiers, @atlanta, @baghdad, @bangkok, @beijing, @bogota, @buenosaires, @cairo, @chennai, @chicago, @delhi, @essen, @hochiminh, @istanbul, @jakarta, @johannesburg, @hongkong, @karachi, @khartoum, @kinshasa, @kolkata, @lagos, @lima, @london, @losangeles, @manila, @madrid, @mexicocity, @miami, @milan, @montreal, @moscow, @mumbai, @newyork, @osaka, @paris, @riyadh, @sanfrancisco, @santiago, @saopaulo, @seoul, @shanghai, @stpetersburg, @sydney, @taipei, @tehran, @tokyo, @washington]

    @infection_cards = []
    @player_cards = []
    assign_cards(:infection)
    assign_cards(:player)
    assign_cards(:event)
    connect_cities
    assign_diseases
    @research_station_built = count_research_station
    @research_station_available = MAX_RESEARCH_STATION - @research_station_built
  end

  # Initialize 48 instances of City Class
  def build_cities
    [@algiers = City.new("Algiers", 2946000, :black),
    @atlanta = City.new("Atlanta", 4715000, :blue),
    @baghdad = City.new("Baghdad", 6204000, :black),
    @bangkok = City.new("Bangkok", 7151000, :red),
    @beijing = City.new("Beijing", 17311000, :red),
    @bogota = City.new("Bogota", 8702000, :yellow),
    @buenosaires = City.new("Buenos Aires", 13639000, :yellow),
    @cairo = City.new("Cairo", 14718000, :black),
    @chennai = City.new("Chennai", 8865000, :black),
    @chicago = City.new("Chicago", 9121000, :blue),
    @delhi = City.new("Delhi", 22242000, :black),
    @essen = City.new("Essen", 575000, :blue),
    @hochiminh = City.new("Ho Chi Minh", 8314000, :red),
    @istanbul = City.new("Istanbul", 13576000, :black),
    @jakarta = City.new("Jakarta", 26063000, :red),
    @johannesburg = City.new("Johannesburg", 3888000, :yellow),
    @hongkong = City.new("Hong Kong", 7106000, :red),
    @karachi = City.new("Johannesburg", 20711000, :black),
    @khartoum = City.new("Khartoum", 4887000, :yellow),
    @kinshasa = City.new("Kinshasa", 9046000, :yellow),
    @kolkata = City.new("Kolkata", 14374000, :black),
    @lagos = City.new("Lagos", 11547000, :yellow),
    @lima = City.new("Lima", 9121000, :yellow),
    @london = City.new("London", 8586000, :blue),
    @losangeles = City.new("Los Angeles", 14900000, :yellow),
    @manila = City.new("Manila", 2767000, :red),
    @madrid = City.new("Madrid", 5427000, :blue),
    @mexicocity = City.new("Mexico City", 19463000, :yellow),
    @miami = City.new("Miami", 5582000, :yellow),
    @milan = City.new("Milan", 5232000, :blue),
    @montreal = City.new("Montreal", 3429000, :blue),
    @moscow = City.new("Moscow", 15512000, :black),
    @mumbai = City.new("Mumbai", 16910000, :black),
    @newyork = City.new("New York", 20464000, :blue),
    @osaka = City.new("Osaka", 2871000, :red),
    @paris = City.new("Paris", 10755000, :blue),
    @riyadh = City.new("Riyadh", 5037000, :black),
    @sanfrancisco = City.new("San Francisco", 5864000, :blue),
    @santiago = City.new("Santiago", 6015000, :yellow),
    @saopaulo = City.new("Sao Paulo", 20186000, :yellow),
    @seoul = City.new("Seoul", 22547000, :red),
    @shanghai = City.new("Shanghai", 13482000, :red),
    @stpetersburg = City.new("St Petersburg", 4879000, :blue),
    @sydney = City.new("Sydney", 3785000, :red),
    @taipei = City.new("Taipei", 8338000, :red),
    @tehran = City.new("Tehran", 7419000, :black),
    @tokyo = City.new("Tokyo", 13189000, :red),
    @washington = City.new("Washington", 4679000, :blue)]
  end

  #Connect Cities
  def connect_cities
    @algiers.add_neighbors([@madrid, @paris, @istanbul, @cairo])
    @atlanta.add_neighbors([@chicago, @washington, @miami])
    @baghdad.add_neighbors([@istanbul, @tehran, @karachi, @riyadh, @cairo])
    @bangkok.add_neighbors([@kolkata, @hongkong, @hochiminh, @jakarta, @chennai])
    @beijing.add_neighbors([@seoul, @shanghai])
    @bogota.add_neighbors([@mexicocity, @miami, @saopaulo, @buenosaires, @lima])
    @buenosaires.add_neighbors([@saopaulo, @bogota])
    @cairo.add_neighbors([@algiers, @istanbul, @baghdad, @riyadh, @khartoum])
    @chennai.add_neighbors([@mumbai, @delhi, @kolkata, @bangkok, @jakarta])
    @chicago.add_neighbors([@sanfrancisco, @losangeles, @mexicocity, @atlanta, @montreal])
    @delhi.add_neighbors([@tehran, @karachi, @mumbai, @chennai, @kolkata])
    @essen.add_neighbors([@london, @paris, @milan, @stpetersburg])
    @hochiminh.add_neighbors([@jakarta, @bangkok, @hongkong, @manila])
    @istanbul.add_neighbors([@milan, @stpetersburg, @moscow, @baghdad, @cairo, @algiers])
    @jakarta.add_neighbors([@chennai, @bangkok, @hochiminh, @sydney])
    @johannesburg.add_neighbors([@kinshasa, @khartoum])
    @hongkong.add_neighbors([@kolkata, @shanghai, @taipei, @manila, @hochiminh, @bangkok])
    @karachi.add_neighbors([@baghdad, @tehran, @delhi, @mumbai, @riyadh])
    @khartoum.add_neighbors([@cairo, @lagos, @kinshasa, @johannesburg])
    @kinshasa.add_neighbors([@lagos, @khartoum, @johannesburg])
    @kolkata.add_neighbors([@delhi, @chennai, @bangkok, @hongkong])
    @lagos.add_neighbors([@khartoum, @saopaulo])
    @lima.add_neighbors([@mexicocity, @bogota, @santiago])
    @london.add_neighbors([@newyork, @madrid, @paris, @essen])
    @losangeles.add_neighbors([@sydney, @sanfrancisco, @chicago, @mexicocity])
    @manila.add_neighbors([@sydney, @hochiminh, @hongkong, @taipei, @sanfrancisco])
    @madrid.add_neighbors([@newyork, @london, @paris, @algiers, @saopaulo])
    @mexicocity.add_neighbors([@losangeles, @chicago, @miami, @bogota, @lima])
    @miami.add_neighbors([@washington, @atlanta, @mexicocity, @bogota])
    @milan.add_neighbors([@essen, @paris, @istanbul])
    @montreal.add_neighbors([@chicago, @washington, @newyork])
    @moscow.add_neighbors([@stpetersburg, @istanbul, @tehran])
    @mumbai.add_neighbors([@karachi, @delhi, @chennai])
    @newyork.add_neighbors([@montreal, @washington, @london, @madrid])
    @osaka.add_neighbors([@tokyo, @taipei])
    @paris.add_neighbors([@london, @essen, @milan, @algiers, @madrid])
    @riyadh.add_neighbors([@cairo, @baghdad, @karachi])
    @sanfrancisco.add_neighbors([@tokyo, @manila, @losangeles, @chicago])
    @santiago.add_neighbors([@lima])
    @saopaulo.add_neighbors([@buenosaires, @bogota, @madrid, @lagos])
    @seoul.add_neighbors([@beijing, @shanghai, @tokyo])
    @shanghai.add_neighbors([@beijing, @seoul, @tokyo, @taipei, @hongkong])
    @stpetersburg.add_neighbors([@essen, @istanbul, @moscow])
    @sydney.add_neighbors([@jakarta, @manila, @losangeles])
    @taipei.add_neighbors([@osaka, @shanghai, @hongkong, @manila])
    @tehran.add_neighbors([@moscow, @baghdad, @karachi, @delhi])
    @tokyo.add_neighbors([@seoul, @shanghai, @osaka])
    @washington.add_neighbors([@newyork, @montreal, @atlanta, @miami])
  end

  def assign_diseases
    @red_disease = Disease.new(:red)
    @yellow_disease = Disease.new(:yellow)
    @blue_disease = Disease.new(:blue)
    @black_disease = Disease.new(:black)
  end

  def research_station_cities
    r_s_c = []
    @cities.each do |city|
      if city.research_st
        r_s_c << city
      end
    end
    r_s_c
  end

  #Assign the 48 Player Cards and Infection Cards
  def assign_cards(type)
    if type == :infection || type == :player
      @cities.each do |city|
        if type == :infection
          @infection_cards << InfectionCard.new(city.name, city.original_color)
        else
          @player_cards << PlayerCard.new(city.name, city.original_color, city.population)
        end
      end
    end
    if type == :event
      EVENT_CARDS.keys.each do |event_type|
        @player_cards << EventCard.new(event_type, EVENT_CARDS[event_type])
      end
    end
  end

  def count_research_station
    cities = research_station_cities
    @research_station_built = cities.size
    @research_station_available = MAX_RESEARCH_STATION - @research_station_built
  end

  def player_cards_cities
    cities = @player_cards.select {|card| card.type == :player}
  end

  def player_cards_events
    events = @player_cards.select {|card| card.type == :event}
  end

  def player_cards_city_names
    cities = player_cards_cities
    cities.collect {|card| card.cityname}
  end

  def player_cards_event_names
    events = player_cards_events
    events.collect {|card| card.event.to_s}
  end


  EVENT_CARDS = {
    Resilient_Population: "Play at anytime, Not an action. Remove any 1 card in the infection dicard pile from the Game. You may play this between the infect and intensify steps of an epidemic.",
    Government_Grant: "Play at anytime, Not an action. Add 1 research station to any city (no city card needed).",
    Airlift: "Play at anytime, Not an action. Nive any 1 pawn to any city. Get permission before moving another player's pawn.",
    One_Quiet_Night: "Play at anytime, Not an action. Skip the next infect cities step (do not flip over any infection cards).",
    Forecast: "Play at anytime, Not an action. Draw, look at, and rearrange the top 6 cards of the infection deck. Put them back on top."
  }

  MAX_RESEARCH_STATION = 6

end
