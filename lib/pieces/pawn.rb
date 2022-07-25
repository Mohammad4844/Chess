require_relative 'piece'
require_relative '../board_checkers'

class Pawn < Piece
  def initialize(team, x, y)
    super(team, x, y, 1)
  end

  def possible_moves(board_spaces)
    moves = []
    if inside_board?(@x, @y + move_step) && board_spaces[@x][@y + move_step].no_piece?
      moves << [@x, @y + move_step]
    end
    if inside_board?(@x + 1, @y + move_step) &&
       board_spaces[@x + 1][@y + move_step].different_team?(self)
      moves << [@x + 1, @y + move_step]
    end
    if inside_board?(@x - 1, @y + move_step) &&
       board_spaces[@x - 1][@y + move_step].different_team?(self)
      moves << [@x - 1, @y + move_step]
    end
    if in_starting_position? && board_spaces[@x][@y + 2 * move_step].no_piece? &&
       board_spaces[@x][@y + move_step].no_piece?
      moves << [@x, @y + 2 * move_step]
    end
    moves
  end

  def move_step
    white? ? 1 : -1
  end

  def promotable?
    (white? && y == 7) || (black? && y.zero?)
  end

  def in_starting_position?
    (white? && @y == 1) || (black? && @y == 6)
  end

  def to_s
    super("\u2659", "\u265F")
  end
end
