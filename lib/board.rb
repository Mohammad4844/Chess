require_relative 'initial_setup'
require_relative 'colorize'
require 'json'

class Board
  include InitialSetup

  attr_accessor :spaces, :current_piece, :kings

  def initialize(spaces = setup_board, kings = nil)
    @spaces = spaces
    @current_piece = nil
    @kings = kings.nil? ? get_starting_kings : kings
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

  def checkmate?(team)
    my_king = @kings[team]
    my_pieces = @spaces.flatten.select { |piece| piece.same_team?(my_king) }
    check?(team) &&
      my_pieces.none? { |piece| piece_has_move_to_remove_check?([piece.x, piece.y]) }
  end

  def check?(team)
    my_king = @kings[team]
    enemy_pieces = @spaces.flatten.select { |piece| piece.different_team?(my_king) }
    enemy_pieces.any? { |piece| piece.possible_moves(@spaces).include?([my_king.x, my_king.y]) }
  end

  def piece_has_move_to_remove_check?((x, y))
    piece = @spaces[x][y]
    piece.possible_moves(@spaces).any? do |move|
      hypothetical_move_removes_check?([piece.x, piece.y], move, piece.team)
    end
  end

  def hypothetical_move_causes_check?((x1, y1), (x2, y2), team)
    hypothetical_board = Marshal.load(Marshal.dump(self))
    hypothetical_board.set_current_piece([x1, y1])
    hypothetical_board.move_current_piece([x2, y2])
    hypothetical_board.check?(team)
  end

  def hypothetical_move_removes_check?((x1, y1), (x2, y2), team)
    hypothetical_board = Marshal.load(Marshal.dump(self))
    hypothetical_board.set_current_piece([x1, y1])
    hypothetical_board.move_current_piece([x2, y2])
    !hypothetical_board.check?(team)
  end

  def legal_move?((x, y))
    moves = @current_piece.possible_moves(@spaces)
    if check?(@current_piece.team)
      moves.select! do |move|
        hypothetical_move_removes_check?([@current_piece.x, @current_piece.y], move, @current_piece.team) 
      end
    else
      moves.select! do |move|
        !hypothetical_move_causes_check?([@current_piece.x, @current_piece.y], move, @current_piece.team) 
      end
    end
    moves.include?([x, y])
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
        if @kings.to_a.any? { |pair| pair[1].x == i && pair[1].y == 7 - j && check?(pair[0]) }
          s << " #{piece_at([i, 7 - j])}".bg_red + ' '.bg_red
        elsif !@current_piece.nil? && legal_move?([i, 7 - j]) &&
          s << " #{piece_at([i, 7 - j])}".bg_green + ' '.bg_green
        elsif (i.even? && j.even?) || (i.odd? && j.odd?)
          s << " #{piece_at([i, 7 - j])}".bg_magenta + ' '.bg_magenta
        else
          s << " #{piece_at([i, 7 - j])}".bg_gray + ' '.bg_gray
        end
      end
    end
    s << "\n   a  b  c  d  e  f  g  h \n".italic
  end

  def to_json; end

  def self.from_json(string); end
end

