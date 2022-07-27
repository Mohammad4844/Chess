require_relative 'board_helpers'
require_relative 'colorize'
require 'json'

class Board
  include BoardHelpers

  attr_accessor :spaces, :current_piece, :kings, :previous_piece

  def initialize(spaces = setup_board, kings = nil, previous_piece = nil)
    @spaces = spaces
    @current_piece = nil
    @previous_piece = previous_piece
    @kings = kings.nil? ? get_starting_kings : kings
  end

  def self.code_to_coordinates(code)
    [code[0].ord - 97, code[1].to_i - 1]
  end

  def set_current_piece((x, y))
    @current_piece = @spaces[x][y]
  end

  def move_current_piece((x, y))
    if en_passant_move?([x, y])
      en_passant_move([x, y])
    else
      regular_move([x, y])
    end
  end

  def regular_move((x, y))
    @spaces[@current_piece.x][@current_piece.y] = NoPiece.new(@current_piece.x, @current_piece.y)
    @spaces[x][y] = @current_piece
    @spaces[x][y].change_coordinates(x, y)
    remove_current_piece
  end

  def checkmate?(team)
    my_king = @kings[team]
    my_pieces = get_my_pieces(my_king)
    check?(team) &&
      my_pieces.none? { |piece| piece_has_move_to_remove_check?([piece.x, piece.y]) }
  end

  def check?(team)
    my_king = @kings[team]
    enemy_pieces = get_enemy_pieces(my_king)
    enemy_pieces.any? do |piece|
      piece.possible_moves(@spaces, @previous_piece).include?([my_king.x, my_king.y])
    end
  end

  def stalemate?(team)
    my_king = @kings[team]
    my_pieces = get_my_pieces(my_king)
    !check?(team) &&
    my_pieces.all? do |piece|
      moves = piece.possible_moves(@spaces, @previous_piece)
      moves.empty? || moves.all? do |move|
        hypothetical_move_causes_check?([piece.x, piece.y], move, team)
      end
    end
  end

  def piece_has_move_to_remove_check?((x, y))
    piece = @spaces[x][y]
    piece.possible_moves(@spaces, @previos_piece).any? do |move|
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
    moves = @current_piece.possible_moves(@spaces, @previous_piece)
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
    @previous_piece = @current_piece
    @current_piece = nil
  end

  def piece_at((x, y))
    @spaces[x][y]
  end

  def get_my_pieces(my_king)
    @spaces.flatten.select { |piece| piece.same_team?(my_king) }
  end

  def get_enemy_pieces(my_king)
    @spaces.flatten.select { |piece| piece.different_team?(my_king) }
  end

  def en_passant_move?((x, y))
    # Only thing really needed to be checked is if the space is a diagonal and
    # has no piece as all other checks are done in #possible_moves
    @current_piece.pawn? && piece_at([x, y]).no_piece? &&
    (@current_piece.x - x).abs == 1 && (@current_piece.y - y).abs == 1
  end

  def en_passant_move((x, y))
    move_step = @current_piece.move_step
    regular_move([x, y - move_step])
    set_current_piece([x, y - move_step])
    regular_move([x, y])
  end

  def promote(team, class_name)
    my_pieces = get_my_pieces(@kings[team])
    pawn = my_pieces.find { |piece| piece.instance_of?(Pawn) && piece.promotable? }
    promoted_piece = Module.const_get(class_name).new(pawn.team, pawn.x, pawn.y)
    @spaces[pawn.x][pawn.y] = promoted_piece
  end

  def any_pawn_promotable?(team)
    my_pieces = get_my_pieces(@kings[team])
    my_pieces.any? { |piece| piece.pawn? && piece.promotable? }
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
      kings: @kings,
      previous_piece: @previous_piece
    })
  end

  def self.from_json(s)
    data = JSON.parse(s)
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

    prev_piece_data = data['previous_piece']
    prev_piece = spaces[prev_piece_data['x']][prev_piece_data['y']]

    w_king = data['kings']['w']; b_king = data['kings']['b']
    kings = { 'w' => spaces[w_king['x']][w_king['y']], 'b' => spaces[b_king['x']][b_king['y']] }
    Board.new(spaces, kings, prev_piece)
  end
end
