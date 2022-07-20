require_relative 'initial_setup'
require 'io/console'
require_relative 'colorize'

class Board
  include InitialSetup

  attr_accessor :spaces, :current_piece

  def initialize
    @spaces = setup_board
    @current_piece = nil
  end

  def set_current_piece(x, y)
    @current_piece = @spaces[x][y]
  end

  def move_current_piece(x, y)
    @spaces[@current_piece.x][@current_piece.y] = NoPiece.new(@current_piece.x, @current_piece.y)
    @spaces[x][y] = @current_piece
    @spaces[x][y].x = x; @spaces[x][y].y = y
    remove_current_piece
  end

  def legal_move?(x, y)
    @current_piece.possible_moves(@spaces).include?([i, j])
    # TODO
  end

  def remove_current_piece
    @current_piece = nil
  end

  def to_s
    s = ''
    for j in 0..7 do
      s << "\n#{8 - j} ".italic
      for i in 0..7 do
        if !@current_piece.nil? && @current_piece.possible_moves(@spaces).include?([i, 7 - j])
          s << " #{@spaces[i][7 - j].to_s}".bg_green + ' '.bg_green
        elsif (i.even? && j.even?) || (i.odd? && j.odd?)
          s << " #{@spaces[i][7 - j].to_s}".bg_magenta + ' '.bg_magenta
        else
          s << " #{@spaces[i][7 - j].to_s}".bg_gray + ' '.bg_gray
        end
      end
    end
    s << "\n   a  b  c  d  e  f  g  h \n".italic
  end

  def to_json
    # TODO
  end

  def from_json
    # TODO
  end
end

board = Board.new
puts board
board.set_current_piece(0,1)
board.move_current_piece(0, 3)
puts board

board.set_current_piece(3,0)
puts board
board.move_current_piece(3, 2)
puts board

board.set_current_piece(3,2)
puts board




# $stdout.clear_screen


