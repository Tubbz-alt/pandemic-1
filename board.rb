# Board
require_relative "city"
require_relative "infectioncard"
require_relative "playercard"

class Board

  attr_reader :cities, :infection_cards, :player_cards

  def initialize
    @cities = build_cities
    @infection_cards = assign_cards(:infection)
    @player_cards = assign_cards(:player)
  end

  # Initialize 48 instances of City Class
  def build_cities
    [algiers = City.new("Algiers", 2946000, :black),
    atlanta = City.new("Atlanta", 4715000, :blue),
    baghdad = City.new("Baghdad", 6204000, :black),
    bangkok = City.new("Bangkok", 7151000, :red),
    beijing = City.new("Beijing", 17311000, :red),
    bogota = City.new("Bogota", 8702000, :yellow),
    buenosaires = City.new("Buenos Aires", 13639000, :yellow),
    cairo = City.new("Cairo", 14718000, :black),
    chennai = City.new("Chennai", 8865000, :black),
    chicago = City.new("Chicago", 9121000, :blue),
    delhi = City.new("Delhi", 22242000, :black),
    essen = City.new("Essen", 575000, :blue),
    hochiminh = City.new("Ho Chi Minh", 8314000, :red),
    istanbul = City.new("Istanbul", 13576000, :black),
    jakarta = City.new("Jakarta", 26063000, :red),
    johannesburg = City.new("Johannesburg", 3888000, :yellow),
    hongkong = City.new("Hong Kong", 7106000, :red),
    karachi = City.new("Johannesburg", 20711000, :black),
    khartoum = City.new("Khartoum", 4887000, :yellow),
    kinshasa = City.new("Kinshasa", 9046000, :yellow),
    kolkata = City.new("Kolkata", 14374000, :black),
    lagos = City.new("Lagos", 11547000, :yellow),
    lima = City.new("Lima", 9121000, :yellow),
    london = City.new("London", 8586000, :blue),
    losangeles = City.new("Los Angeles", 14900000, :yellow),
    manila = City.new("Manila", 2767000, :red),
    madrid = City.new("Madrid", 5427000, :blue),
    mexicocity = City.new("Mexico City", 19463000, :yellow),
    miami = City.new("Miami", 5582000, :yellow),
    milan = City.new("Milan", 5232000, :blue),
    montreal = City.new("Montreal", 3429000, :blue),
    moscow = City.new("Moscow", 15512000, :black),
    mumbai = City.new("Mumbai", 16910000, :black),
    newyork = City.new("New York", 20464000, :blue),
    osaka = City.new("Osaka", 2871000, :red),
    paris = City.new("Paris", 10755000, :blue),
    riyadh = City.new("Riyadh", 5037000, :black),
    sanfrancisco = City.new("San Francisco", 5864000, :blue),
    santiago = City.new("Santiago", 6015000, :yellow),
    saopaolo = City.new("Sao Paolo", 20186000, :yellow),
    seoul = City.new("Seoul", 22547000, :red),
    shanghai = City.new("Shanghai", 13482000, :red),
    stpetersburg = City.new("St Petersburg", 4879000, :blue),
    sydney = City.new("Sydney", 3785000, :red),
    taipei = City.new("Taipei", 8338000, :red),
    tehran = City.new("Tehran", 7419000, :black),
    tokyo = City.new("Tokyo", 13189000, :red),
    washington = City.new("Washington", 4679000, :blue)]
  end

  #Connect Cities
  def connect_cities

  end

  #Assign the 48 Player Cards and Infection Cards
  def assign_cards(type)
    @cities.collect do |city|
      if type == :infection
        city = InfectionCard.new(city.name)
      elsif type == :player
        city = PlayerCard.new(city.name, city.original_color)
      end
    end
  end

end
