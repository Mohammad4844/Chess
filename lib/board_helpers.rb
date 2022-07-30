# frozen_string_literal: true

require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/queen'
require_relative 'pieces/pawn'
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
    (0..7).reduce("\n   a  b  c  d  e  f  g  h ".italic) do |grid, j|
      grid + "\n#{8 - j} ".italic +
        (0..7).reduce('') do |line, i|
          line + get_space_to_s(i, 7 - j)
        end + " #{8 - j}".italic
    end + "\n   a  b  c  d  e  f  g  h \n".italic
  end

  def get_space_to_s(x, y)
    if @kings.to_a.any? { |pair| pair[1].x == x && pair[1].y == y && check?(pair[0]) }
      " #{piece_at([x, y])}".bg_red + ' '.bg_red
    elsif !@current_piece.nil? && legal_move?([x, y])
      " #{piece_at([x, y])}".bg_green + ' '.bg_green
    elsif (x.even? && y.even?) || (x.odd? && y.odd?)
      " #{piece_at([x, y])}".bg_magenta + ' '.bg_magenta
    else
      " #{piece_at([x, y])}".bg_gray + ' '.bg_gray
    end
  end
end
