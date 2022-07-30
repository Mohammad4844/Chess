# frozen_string_literal: true

require_relative 'piece'

class Knight < Piece
  def initialize(team, x, y)
    super(team, x, y, 3)
  end

  def possible_moves(board_spaces, _previous_piece = '')
    moves = []
    directions.each do |dir|
      if inside_board?(@x + dir[0], @y + dir[1]) && !board_spaces[@x + dir[0]][@y + dir[1]].same_team?(self)
        moves << [@x + dir[0], @y + dir[1]]
      end
    end
    moves
  end

  def to_s
    super("\u2658", "\u265E")
  end

  private 

  def directions
    [[1, 2], [-1, 2], [1, -2], [-1, -2],
      [2, 1], [2, -1], [-2, 1], [-2, -1]]
  end
end