require_relative 'piece'

class Knight < Piece
  def initialize(team, x, y)
    super(team, x, y, 3)
  end

  def to_s
    super("\u2658", "\u265E")
  end
end