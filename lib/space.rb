require_relative 'coordinate'
require_relative 'colorize'
require_relative 'pieces/piece'
require_relative 'pieces/pawn'

class Space
  def initialize(x, y, piece = ' ')
    @coordinate = Coordinate.new(x, y)
    @piece = piece
  end

  def location_key
    letters = ['a', 'b', 'c', 'd', 'e', 'f']
    "#{letters[@coordinate[:x]]}#{@coordinate[:y] + 1}"
  end

  def to_s
    if (@coordinate[:x].even? && @coordinate[:y].even?) ||
      (@coordinate[:x].odd? && @coordinate[:y].odd?)
      " #{@piece}".bg_magenta + ' '.bg_magenta
    else
      " #{@piece}".bg_gray + ' '.bg_gray
    end
  end
end
