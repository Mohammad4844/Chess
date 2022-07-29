require_relative '../../lib/pieces/bishop'
require_relative '../../lib/board'

describe Bishop do
  describe '#possible_moves' do
    let(:board) { Board.new }

    before do
      board.spaces = Array.new(8) { |i| Array.new(8) { |j| NoPiece.new(i, j) } }
      board.spaces[3][3] = Bishop.new('w', 3, 3)
    end

    it 'can slide in all 4 diagonal directions' do
      w_bishop = board.spaces[3][3]
      moves = w_bishop.possible_moves(board.spaces, board.previous_piece)
      all_legal_moves = [
        [0, 0], [1, 1], [2, 2], [4, 4], [5, 5], [6, 6], [7, 7],
        [0, 6], [1, 5], [2, 4], [4, 2], [5, 1], [6, 0]
      ]
      expect(moves).to match_array(all_legal_moves)
    end

    context 'when path is blocked' do
      context 'by ally piece' do
        before do
          board.spaces[5][1] = Queen.new('w', 5, 1)
        end

        it 'can slide till before the piece' do
          w_bishop = board.spaces[3][3]
          moves = w_bishop.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to include([4, 2])
        end

        it 'cannot go through the piece' do
          w_bishop = board.spaces[3][3]
          moves = w_bishop.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to_not include([5, 1], [6, 0])
        end
      end

      context 'by enemy piece' do
        before do
          board.spaces[6][6] = Knight.new('b', 6, 6)
        end

        it 'can slide till the piece and take it' do
          w_bishop = board.spaces[3][3]
          moves = w_bishop.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to include([4, 4], [5, 5], [6, 6])
        end

        it 'cannot go through the piece' do
          w_bishop = board.spaces[3][3]
          moves = w_bishop.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to_not include([7, 7])
        end
      end
    end
  end
end
