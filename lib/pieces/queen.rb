require_relative 'piece'

class Queen < Piece
  def initialize(team, x, y)
    super(team, x, y, 9)
  end

  def possible_moves(board_spaces)
    get_orthogonal_moves(board_spaces) + get_diagonal_moves(board_spaces)
  end

  def to_s
    super("\u2655", "\u265B")
  end
end