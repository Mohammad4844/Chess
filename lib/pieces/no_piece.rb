require_relative 'piece'

class NoPiece < Piece
  def initialize(x, y)
    super('', x, y, 0)
  end

  def no_piece?
    true
  end

  def to_s
    ' '
  end
end
