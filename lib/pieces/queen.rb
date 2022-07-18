require_relative 'piece'

class Queen < Piece
  def initialize(team, x, y)
    super(team, x, y, 9)
  end

  def to_s
    super("\u2655", "\u265B")
  end
end