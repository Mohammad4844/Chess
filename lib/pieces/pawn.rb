require_relative 'piece'

class Pawn < Piece
  def initialize(team, x, y)
    super(team, x, y, 1)
  end

  def possible_moves(board_spaces)
    moves = []
    moves << [@x, @y + move_step] if board_spaces[@x][@y + move_step].no_piece?
    moves << [@x + 1, @y + move_step] if board_spaces[@x + 1][@y + move_step].different_team?(self)
    moves << [@x - 1, @y + move_step] if board_spaces[@x - 1][@y + move_step].different_team?(self)
    moves << [@x, @y + 2 * move_step] if in_starting_position? &&
      board_spaces[@x][@y + 2 * move_step].no_piece? && board_spaces[@x][@y + move_step].no_piece?
    moves
  end

  def move_step
    white? ? 1 : -1
  end

  def in_starting_position?
    return true if (white? && @y == 1) || (black? && @y == 6)
  end

  def to_s
    super("\u2659", "\u265F")
  end
end
