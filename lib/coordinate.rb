class Coordinate < Hash
  def initialize(x, y)
    self[:x] = x
    self[:y] = y
  end
end