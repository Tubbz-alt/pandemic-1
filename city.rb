# City
require_relative "board"

class City

  MAX_COLOR = 3

  attr_reader :name, :population, :original_color, :neighbors, :research_st, :red, :yellow, :black, :blue, :outbreak
  attr_accessor :pawns

  def initialize(name, population, original_color)
    @name = name
    @population = population
    @original_color = original_color
    @neighbors = []
    @red = 0
    @yellow = 0
    @black = 0
    @blue = 0
    @pawns = []
    @outbreak = false

    if @name == "Atlanta"
      @research_st = true
    else
      @research_st = false
    end
    @research_station_availability = 5
  end

  def add_neighbors(neighbors)
    neighbors.each do |neighbor|
      if !@neighbors.include?(neighbor)
        @neighbors.push(neighbor)
      end
      if !neighbor.neighbors.include?(self)
        neighbor.neighbors.push(self)
      end
    end
  end


  def build_research_st
    @research_st = true
  end

  def remove_research_st
    @research_at = false
  end

  def pawn_move_to_city(player)
    @pawns.push(player.pawn)
  end

  def pawn_move_from_city(player)
    @pawns.delete(player.pawn)
  end

  def color_count
    @red + @blue + @yellow + @black
  end

  def infect(disease = @original_color, number = 1)
    case disease
    when :red
      @red += number
    when :yellow
      @yellow += number
    when :black
      @black += number
    when :blue
      @blue += number
    end
  end


  def treat(disease, number = 1)
    case disease
    when :red
      @red -= number
    when :yellow
      @yellow -= number
    when :black
      @black -= number
    when :blue
      @blue -= number
    end
  end

  def outbreak_happens
    @outbreak = true
  end

  def outbreak_reset
    @outbreak = false
  end

  def show_neighbors #CommandLine
    @neighbors.each do |neighbor|
      if neighbor.research_st
        research_st_indication = neighbor.research_st.to_s.upcase
      else
        research_st_indication = neighbor.research_st.to_s
      end

      puts neighbor.name.to_s + ". Players : "+ neighbor.pawns.to_s + ". Cubes : " + neighbor.color_count.to_s + ". Red, Yellow, Black, Blue : " + neighbor.red.to_s + ", "+ neighbor.yellow.to_s + ", "+ neighbor.black.to_s + ", "+ neighbor.blue.to_s + ". Research St : "+research_st_indication
    end
    puts
  end

  def show_info #CommandLine
    if @research_st
      research_st_indication = @research_st.to_s.upcase
    else
      research_st_indication = @research_st.to_s
    end

    puts "Players : "+@pawns.to_s+". Cubes : "+self.color_count.to_s+". Red, Yellow, Black, Blue : " + @red.to_s + ", "+ @yellow.to_s + ", "+ @black.to_s + ", "+ @blue.to_s + ". Research St : "+research_st_indication
    puts
  end


end
