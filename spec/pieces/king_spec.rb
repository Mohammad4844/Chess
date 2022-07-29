require_relative '../../lib/pieces/king'
require_relative '../../lib/board'

describe King do
  describe '#possible_moves' do
    let(:board) { Board.new }

    before do
      board.spaces[3][3] = King.new('w', 3, 3)
    end

    it 'can move to all its neighbouring pieces' do
      w_king = board.spaces[3][3]
      moves = w_king.possible_moves(board.spaces, board.previous_piece)
      all_legal_moves = [
        [2, 2], [2, 3], [2, 4], [3, 4], [4, 4], [4, 3], [4, 2], [3, 2]
      ]
      expect(moves).to match_array(all_legal_moves)
    end
  end
end
