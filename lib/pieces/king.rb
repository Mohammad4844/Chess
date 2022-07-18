require_relative 'piece'

class King < Piece
  def initialize(team, x, y)
    super(team, x, y)
  end

  def to_s
    super("\u2654", "\u265A")
  end
end
