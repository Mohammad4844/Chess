require_relative 'piece'

class King < Piece
  def initialize(team, x, y)
    super(team, x, y)
  end

  def possible_moves(board_spaces)
      moves = []
      directions.each do |dir|
        if inside_board?(@x + dir[0], @y + dir[1]) && !board_spaces[@x + dir[0]][@y + dir[1]].same_team?(self)
          moves << [@x + dir[0], @y + dir[1]]
        end
      end
      moves
  end

  def to_s
    super("\u2654", "\u265A")
  end

  private

  def directions
    [
      [0, 1], [1, 0],
      [-1, 0], [0, -1],
      [1, 1], [-1, -1],
      [1, -1], [-1, 1]
    ]
  end
end
