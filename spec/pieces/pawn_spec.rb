require_relative '../../lib/pieces/pawn'
require_relative '../../lib/board'

describe Pawn do
  describe '#possible_moves' do
    let(:board) { Board.new }

    context 'normal move:' do
      before do
        board.spaces[3][3] = Pawn.new('w', 3, 3)
      end

      it 'can move one space to its front' do
        w_pawn = board.spaces[3][3]
        moves = w_pawn.possible_moves(board.spaces, board.previous_piece)
        expect(moves).to include([3, 4])
      end

      it 'cant move one space if it has emeny piece' do
        board.spaces[3][4] = Pawn.new('w', 3, 4)
        w_pawn = board.spaces[3][3]
        moves = w_pawn.possible_moves(board.spaces, board.previous_piece)
        expect(moves).to_not include([3, 4])
      end
    end

    context 'diagonal move:' do
      context 'if enemy piece is on diagonal' do
        before do
          board.spaces[2][2] = Rook.new('b', 2, 2)
        end

        it 'can move to its diagonal' do
          w_pawn = board.spaces[1][1]
          moves = w_pawn.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to include([2, 2])
        end
      end

      context 'if no enemy piece is on diagonal' do
        it 'cannot move to its diagonal' do
          w_pawn = board.spaces[1][1]
          moves = w_pawn.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to_not include([2, 2])
        end
      end
    end

    context '2 ranks as first move:' do
      context 'when it is pawns first move' do
        it 'can move 2 spaces' do
          w_pawn = board.spaces[1][1]
          moves = w_pawn.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to include([1, 3])
        end
      end

      context 'when it is not pawns first move' do
        before do
          board.set_current_piece([1, 1])
          board.move_current_piece([1, 2])
        end

        it 'cannot move 2 spaces' do
          w_pawn = board.spaces[1][2]
          moves = w_pawn.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to_not include([1, 4])
        end
      end

      context 'when it is pawns first move but front space is blocked' do
        before do
          board.spaces[1][2] = Rook.new('b', 1, 2)
        end

        it 'cannot move 2 spaces' do
          w_pawn = board.spaces[1][1]
          moves = w_pawn.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to_not include([1, 3])
        end
      end
    end

    context 'en passant:' do
      context 'if enemy pawn is in en passant' do
        before do
          board.spaces[1][4] = Pawn.new('w', 1, 4)
          board.set_current_piece([0, 6])
          board.move_current_piece([0, 4])
        end

        it 'can move diagonally' do
          w_pawn = board.spaces[1][4]
          moves = w_pawn.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to include([0, 5])
        end
      end

      context 'if enemy pawn is beside but it wasnt the most recent move' do
        before do
          board.spaces[1][4] = Pawn.new('w', 1, 4)
          board.set_current_piece([0, 6])
          board.move_current_piece([0, 4])
          board.set_current_piece([0, 7])
          board.move_current_piece([0, 6])
        end

        it 'cannot move diagonally' do
          w_pawn = board.spaces[1][4]
          moves = w_pawn.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to_not include([0, 5])
        end
      end

      context 'if enemy pawn didnt take a 2 step as the first move' do
        before do
          board.spaces[1][4] = Pawn.new('w', 1, 4)
          board.set_current_piece([0, 6])
          board.move_current_piece([0, 5])
          board.set_current_piece([0, 5])
          board.move_current_piece([0, 4])
        end

        it 'cannot move diagonally' do
          w_pawn = board.spaces[1][4]
          moves = w_pawn.possible_moves(board.spaces, board.previous_piece)
          expect(moves).to_not include([0, 5])
        end
      end
    end
  end
end