require_relative 'pieces/Rook'
require_relative 'pieces/Knight'
require_relative 'pieces/Bishop'
require_relative 'pieces/King'
require_relative 'pieces/Queen'
require_relative 'pieces/Pawn'

module InitialSetup
  def setup_board
    Array.new(8) do |i|
      Array.new(8) do |j|
        Space.new(i, j, starting_piece(i, j))
      end
    end
  end

  def starting_piece(x, y)
    return ' ' if y.between?(2,5)
    y < 2 ? team = 'w' : team = 'b'
    piece_class = starting_class(x, y)
    return piece_class.new(team, x, y)
  end
    
  def starting_class(x, y)
    case y
    when 1, 6 then return Pawn
    end

    case x
    when 0, 7 then Rook
    when 1, 6 then Knight
    when 2, 5 then Bishop
    when 3 then King
    when 4 then Queen
    end
  end
end