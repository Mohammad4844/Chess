class Coordinate < Hash
  def initialize(x, y)
    self[:x] = x
    self[:y] = y
  end

  def ==(other)
    other.instance_of?(Coordinate) && self[:x] == other[:x] && self[:y] == other[:y]
  end

  def change(x, y)
    Coordinate.new(x, y)
  end
end