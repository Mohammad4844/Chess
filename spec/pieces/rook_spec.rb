require_relative '../../lib/pieces/rook'
require_relative '../../lib/board'

describe Rook do
  describe '#possible_moves' do
    let(:board) { Board.new }

    before do
      board.spaces = Array.new(8) { |i| Array.new(8) { |j| NoPiece.new(i, j) } }
      board.spaces[3][3] = Rook.new('w', 3, 3)
    end

    it 'can slide in all 4 orthogonal directions' do
      w_rook = board.spaces[3][3]
      moves = w_rook.possible_moves(board.spaces, board.previous_piece)
      all_legal_moves = [
        [0, 3], [1, 3], [2, 3], [4, 3], [5, 3], [6, 3], [7, 3],
        [3, 0], [3, 1], [3, 2], [3, 4], [3, 5], [3, 6], [3, 7]
      ]
      expect(moves).to match_array(all_legal_moves)
    end

    context 'when path is blocked' do
      context 'by ally piece' do
        before do
          board.spaces[6][3] = Queen.new('w', 6, 3)
        end

        it 'can slide till before the piece' do
          w_rook = board.spaces[3][3]
          moves = w_rook.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to include([4, 3], [5, 3])
        end

        it 'cannot go through the piece' do
          w_rook = board.spaces[3][3]
          moves = w_rook.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to_not include([6, 3], [7, 3])
        end
      end

      context 'by enemy piece' do
        before do
          board.spaces[3][6] = Knight.new('b', 3, 6)
        end

        it 'can slide till the piece and take it' do
          w_rook = board.spaces[3][3]
          moves = w_rook.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to include([3, 4], [3, 5], [3, 6])
        end

        it 'cannot go through the piece' do
          w_rook = board.spaces[3][3]
          moves = w_rook.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to_not include([3, 7])
        end
      end
    end
  end
end
