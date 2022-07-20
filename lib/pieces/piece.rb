require_relative '../board_checkers'
require_relative '../colorize'

class Piece
  include BoardCheckers

  attr_accessor :team, :x, :y, :point_value

  def initialize(team, x, y, point_value = nil)
    @team = team 
    @x = x
    @y = y
    @point_value = point_value
  end

  def same_team?(other)
    self.team == other.team
  end

  def different_team?(other)
    self.team != other.team && self.team != '' && other.team != ''
  end

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

