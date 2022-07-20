require_relative '../coordinate'
require_relative '../colorize'

class Piece
  attr_accessor :team, :x, :y, :point_value

  def initialize(team, x, y, point_value = nil)
    @team = team 
    @x = x
    @y = y
    @point_value = point_value
  end

  def update_possible_moves(coordinates = @coordinates); end

  def no_piece?
    @team == ''
  end

  def white?
    @team == 'w'
  end

  def black?
    @team == 'b'
  end

  def to_s(unicode_w, unicode_b)
    case @team
    when 'w' then unicode_w
    when 'b' then unicode_b.black
    end
  end
end

