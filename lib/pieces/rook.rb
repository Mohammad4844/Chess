require_relative 'piece'

class Rook < Piece
  def initialize(team, x, y)
    super(team, x, y, 5)
  end


  def to_s
    super("\u2656", "\u265C")
  end
end