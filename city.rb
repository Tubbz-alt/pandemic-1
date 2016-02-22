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
    @research_st = false
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
    @research_st = false
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

  def disease_reset(disease)
    case disease
    when :red
      initial = @red
      @red = 0
    when :yellow
      initial = @yellow
      @yellow = 0
    when :black
      initial = @black
      @black = 0
    when :blue
      initial = @blue
      @blue = 0
    end
    return initial
  end

  def outbreak_happens
    @outbreak = true
  end

  def outbreak_reset
    @outbreak = false
  end
  
end
