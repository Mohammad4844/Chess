require_relative 'piece'

class Bishop < Piece
  def initialize(team, x, y)
    super(team, x, y, 3)
  end

  def to_s
    super("\u2657", "\u265D")
  end
end