# frozen_string_literal: true

require_relative 'piece'
require_relative 'slidable'

class Queen < Piece
  include Slidable

  def initialize(team, x, y)
    super(team, x, y, 9)
  end

  def possible_moves(board_spaces, _previous_piece = '')
    get_orthogonal_moves(board_spaces) + get_diagonal_moves(board_spaces)
  end

  def to_s
    super("\u2655", "\u265B")
  end
end