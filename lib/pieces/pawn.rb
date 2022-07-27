require_relative 'piece'
require_relative '../board_checkers'

class Pawn < Piece
  def initialize(team, x, y, en_passant = false)
    super(team, x, y, 1)
    @en_passant = en_passant
  end

  def possible_moves(board_spaces, previous_piece)
    moves = []
    if inside_board?(@x, @y + move_step) && board_spaces[@x][@y + move_step].no_piece?
      moves << [@x, @y + move_step]
    end
    if inside_board?(@x + 1, @y + move_step) &&
       board_spaces[@x + 1][@y + move_step].different_team?(self)
      moves << [@x + 1, @y + move_step]
    end
    if inside_board?(@x - 1, @y + move_step) &&
       board_spaces[@x - 1][@y + move_step].different_team?(self)
      moves << [@x - 1, @y + move_step]
    end
    if in_starting_position? && board_spaces[@x][@y + 2 * move_step].no_piece? &&
       board_spaces[@x][@y + move_step].no_piece?
      moves << [@x, @y + 2 * move_step]
    end
    if !previous_piece.nil? && previous_piece.pawn? && previous_piece.en_passant?
      if inside_board?(@x - 1, @y + move_step) &&
         board_spaces[@x - 1][@y + move_step].no_piece? &&
         board_spaces[@x - 1][@y] == previous_piece
        moves << [@x - 1, @y + move_step]
      end
      if inside_board?(@x + 1, @y + move_step) &&
         board_spaces[@x + 1][@y + move_step].no_piece? &&
         board_spaces[@x + 1][@y] == previous_piece
        moves << [@x + 1, @y + move_step]
      end
    end
    moves
  end

  def change_coordinates(x, y)
    if in_starting_position? && ((white? && y == 3) || (black? && y == 4))
      @en_passant = true
    else
      @en_passant = false
    end
    @x = x
    @y = y
  end

  def move_step
    white? ? 1 : -1
  end

  def promotable?
    (white? && y == 7) || (black? && y.zero?)
  end

  def en_passant?
    @en_passant
  end

  def in_starting_position?
    (white? && @y == 1) || (black? && @y == 6)
  end

  def to_s
    super("\u2659", "\u265F")
  end

  def to_json(args)
    JSON.generate({
      class: self.class,
      team: @team,
      x: @x,
      y: @y,
      en_passant: @en_passant
    })
  end

  def self.from_json(s)
    data = JSON.parse(s)
    data['class'].new(data['team'], data['x'], data['y'], data['en_passant'])
  end
end
