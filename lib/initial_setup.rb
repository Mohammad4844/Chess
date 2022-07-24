require_relative 'pieces/Rook'
require_relative 'pieces/Knight'
require_relative 'pieces/Bishop'
require_relative 'pieces/King'
require_relative 'pieces/Queen'
require_relative 'pieces/Pawn'
require_relative 'pieces/no_piece'

module InitialSetup
  def setup_board
    Array.new(8) { |i| Array.new(8) { |j| starting_piece(i, j) } }
  end

  def starting_piece(x, y)
    return NoPiece.new(x, y) if y.between?(2, 5)

    team = y < 2 ? 'w' : 'b'
    piece_class = starting_class(x, y)
    piece_class.new(team, x, y)
  end

  def starting_class(x, y)
    case y
    when 1, 6 then return Pawn
    end

    case x
    when 0, 7 then Rook
    when 1, 6 then Knight
    when 2, 5 then Bishop
    when 3 then Queen
    when 4 then King
    end
  end

  def get_starting_kings
    { 'w' => @spaces[4][0], 'b' => @spaces[4][7] }
  end
end
