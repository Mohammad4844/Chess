require_relative 'piece'
require_relative 'slidable'

class Rook < Piece
  include Slidable

  def initialize(team, x, y)
    super(team, x, y, 5)
  end

  def possible_moves(board_spaces, _previous_piece = '')
    get_orthogonal_moves(board_spaces)
  end

  def to_s
    super("\u2656", "\u265C")
  end
end