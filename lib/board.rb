require_relative 'initial_setup'
require_relative 'colorize'

class Board
  include InitialSetup

  attr_accessor :spaces, :current_piece

  def initialize(spaces = setup_board)
    @spaces = spaces
    @current_piece = nil
  end

  def self.code_to_coordinates(code)
    [code[0].ord - 97, code[1].to_i - 1]
   end

  def set_current_piece((x, y))
    @current_piece = @spaces[x][y]
  end

  def move_current_piece((x, y))
    @spaces[@current_piece.x][@current_piece.y] = NoPiece.new(@current_piece.x, @current_piece.y)
    @spaces[x][y] = @current_piece
    @spaces[x][y].x = x; @spaces[x][y].y = y
    remove_current_piece
  end

  def legal_move?((x, y))
    @current_piece.possible_moves(@spaces).include?([x, y])
  end

  def remove_current_piece
    @current_piece = nil
  end

  def piece_at((x, y))
    @spaces[x][y]
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

# $stdout.clear_screen


