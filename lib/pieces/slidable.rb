module Slidable
  def get_orthogonal_moves(board_spaces)
    slideable_moves(board_spaces, [[0, 1], [1, 0], [0, -1], [-1, 0]])
  end

  def get_diagonal_moves(board_spaces)
    slideable_moves(board_spaces, [[1, 1], [1, -1], [-1, 1], [-1, -1]])
  end

  def slideable_moves(board_spaces, directions)
    moves = []
    directions.each do |dir|
      init = dir
      while inside_board?(@x + dir[0], @y + dir[1]) && board_spaces[@x + dir[0]][@y + dir[1]].no_piece?
        moves << [@x + dir[0], @y + dir[1]]
        dir = [dir[0] + init[0], dir[1] + init[1]]
      end
      moves << [@x + dir[0], @y + dir[1]] if inside_board?(@x + dir[0], y + dir[1]) && 
        board_spaces[@x + dir[0]][@y + dir[1]].different_team?(self)
    end
    moves
  end
end