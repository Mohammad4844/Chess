require_relative '../../lib/pieces/knight'
require_relative '../../lib/board'

describe Knight do
  describe '#possible_moves' do
    let(:board) { Board.new }

    before do
      board.spaces[3][4] = Knight.new('w', 3, 4)
    end

    it 'can move 2 spaces and then 1 to either side in all directions' do
      w_knight = board.spaces[3][4]
      moves = w_knight.possible_moves(board.spaces, board.previous_piece)
      all_legal_moves = [[1, 3], [1, 5], [2, 2], [2, 6], [4, 2], [4, 6], [5, 3], [5, 5]]
      expect(moves).to match_array(all_legal_moves)
    end

    context 'if blocked' do
      before do
        (-1..1).each do |i|
          (-1..1).each do |j|
            next if i.zero? && j.zero?

            board.spaces[3 + i][4 + j] = Rook.new('b', 3 + i, 4 + j)
          end
        end
      end

      it 'can jump over pieces' do
        w_knight = board.spaces[3][4]
        moves = w_knight.possible_moves(board.spaces, board.previous_piece)
        all_legal_moves = [[1, 3], [1, 5], [2, 2], [2, 6], [4, 2], [4, 6], [5, 3], [5, 5]]
        expect(moves).to match_array(all_legal_moves)
      end
    end
  end
end
