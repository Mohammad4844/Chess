require_relative 'board_helpers'
require_relative 'colorize'
require 'json'

class Board
  include BoardHelpers

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
    enemy_pieces = get_enemy_pieces(my_king)
    enemy_pieces.any? { |piece| piece.possible_moves(@spaces).include?([my_king.x, my_king.y]) }
  end

  def piece_has_move_to_remove_check?((x, y))
    piece = @spaces[x][y]
    piece.possible_moves(@spaces).any? do |move|
      hypothetical_move_removes_check?([piece.x, piece.y], move, piece.team)
    end
  end

  def hypothetical_move_causes_check?((x1, y1), (x2, y2), team)
    board_with_hypothetical_move([x1, y1], [x2, y2]).check?(team)
  end

  def hypothetical_move_removes_check?((x1, y1), (x2, y2), team)
    !board_with_hypothetical_move([x1, y1], [x2, y2]).check?(team)
  end

  def board_with_hypothetical_move((x1, y1), (x2, y2))
    hypothetical_board = clone
    hypothetical_board.set_current_piece([x1, y1])
    hypothetical_board.move_current_piece([x2, y2])
    hypothetical_board
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

  def get_enemy_pieces(my_king)
    @spaces.flatten.select { |piece| piece.different_team?(my_king) }
  end

  def to_s
    board_to_string
  end

  def clone
    Marshal.load(Marshal.dump(self))
  end

  def to_json
    JSON.pretty_generate({
      spaces: @spaces,
      kings: @kings
    })
  end

  def self.from_json(s)
    data = JSON.load(s)
    spaces = data['spaces']

    spaces.map! do |row|
      row.map! do |piece| 
        if piece['class'] == 'NoPiece'
          Module.const_get(piece['class']).new(piece['x'], piece['y'])
        else
          Module.const_get(piece['class']).new(piece['team'], piece['x'], piece['y']) 
        end
      end
    end

    w_king = data['kings']['w']; b_king = data['kings']['b']
    kings = { 'w' => spaces[w_king['x']][w_king['y']], 'b' => spaces[b_king['x']][b_king['y']] }
    Board.new(spaces, kings)
  end
end
