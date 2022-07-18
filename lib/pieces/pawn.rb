require_relative 'piece'

class Pawn < Piece
  def initialize(team, x, y)
    super(team, x, y, 1)
  end

  def to_s
    super("\u2659", "\u265F")
  end
end
