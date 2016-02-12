# Disease

class Disease

  attr_reader :color, :cubes_available, :eradicated, :cured

  def initialize(color)
    @color = color
    @cubes_available = 24
    @eradicated = false
    @cured = false
  end

  def reduce_cubes_available(number = 1)
    @cubes_available -= number
  end

  def increase_cubes_available(number = 1)
    @cubes_available += number
  end

  def eradicate
    @eradicated = true
  end

  def cure
    @cured = true
  end

end
