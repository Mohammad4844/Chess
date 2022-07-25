require_relative 'pieces/Rook'
require_relative 'pieces/Knight'
require_relative 'pieces/Bishop'
require_relative 'pieces/King'
require_relative 'pieces/Queen'
require_relative 'pieces/Pawn'
require_relative 'pieces/no_piece'

module BoardHelpers
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

  def board_to_string
    s = "\n   a  b  c  d  e  f  g  h ".italic
    for j in 0..7 do
      s << "\n#{8 - j} ".italic
      for i in 0..7 do
        if checkmate?('b') &&
           get_enemy_pieces(@kings['b']).any? do |piece|
             piece.x == i && piece.y == 7 - j &&
             piece.possible_moves(@spaces).include?([@kings['b'].x, @kings['b'].y])
           end
          s << " #{piece_at([i, 7 - j])}".bg_blue + ' '.bg_blue
        elsif checkmate?('w') &&
              get_enemy_pieces(@kings['w']).any? do |piece|
                piece.x == i && piece.y == 7 - j &&
                piece.possible_moves(@spaces).include?([@kings['w'].x, @kings['w'].y])
              end
          s << " #{piece_at([i, 7 - j])}".bg_blue + ' '.bg_blue
        elsif @kings.to_a.any? { |pair| pair[1].x == i && pair[1].y == 7 - j && check?(pair[0]) }
          s << " #{piece_at([i, 7 - j])}".bg_red + ' '.bg_red
        elsif !@current_piece.nil? && legal_move?([i, 7 - j])
          s << " #{piece_at([i, 7 - j])}".bg_green + ' '.bg_green
        elsif (i.even? && j.even?) || (i.odd? && j.odd?)
          s << " #{piece_at([i, 7 - j])}".bg_magenta + ' '.bg_magenta
        else
          s << " #{piece_at([i, 7 - j])}".bg_gray + ' '.bg_gray
        end
      end
      s << " #{8 - j}".italic
    end
    s << "\n   a  b  c  d  e  f  g  h \n".italic
    s
  end
end
