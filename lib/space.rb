require_relative 'coordinate'
require_relative 'colorize'
require_relative 'pieces/piece'
require_relative 'pieces/pawn'
require_relative 'pieces/no_piece'

class Space
  attr_accessor :piece

  def initialize(x, y, piece = NoPiece.new)
    @coordinates = Coordinate.new(x, y)
    @piece = piece
  end

  def location_key
    letters = ['a', 'b', 'c', 'd', 'e', 'f']
    "#{letters[@coordinates[:x]]}#{@coordinates[:y] + 1}"
  end

  def white_piece?
    @piece.white?
  end

  def black_piece?
    @piece.black?
  end

  def remove_piece
    temp = @piece
    @piece = NoPiece.new
    temp
  end

  def to_s
    if (@coordinates[:x].even? && @coordinates[:y].even?) ||
      (@coordinates[:x].odd? && @coordinates[:y].odd?)
      " #{@piece}".bg_magenta + ' '.bg_magenta
    else
      " #{@piece}".bg_gray + ' '.bg_gray
    end
  end
end
