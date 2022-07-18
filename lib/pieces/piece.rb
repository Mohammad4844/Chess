require_relative '../coordinate'
require_relative '../colorize'

class Piece

  def initialize(team, x, y, point_value = nil)
    @team = team 
    @coordinates = Coordinate.new(x, y)
    @point_value
  end

  def to_s(unicode_w, unicode_b)
    case @team
    when 'w' then unicode_w
    when 'b' then unicode_b.black
    end
  end
end

