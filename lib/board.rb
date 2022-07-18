require_relative 'space'
require_relative 'initial_setup'

class Board
  include InitialSetup

  def initialize
    @spaces = setup_board
  end

  def to_s(row = @spaces.length - 1)
    s = ''
    for j in 0..7 do
      for i in 0..7 do s << @spaces[i][7 - j].to_s end
      s << "\n"
    end
    s
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