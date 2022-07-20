require_relative 'piece'

class Bishop < Piece
  def initialize(team, x, y)
    super(team, x, y, 3)
  end

  def possible_moves(board_spaces)
    get_diagonal_moves(board_spaces)
  end

  def to_s
    super("\u2657", "\u265D")
  end
end