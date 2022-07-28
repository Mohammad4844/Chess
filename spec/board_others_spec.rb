require_relative '../lib/board'

# Some tests rely on the possible_moves method of each piece working
# Use 'puts board' in any code section to print the board so yu can see it

describe Board do
  describe '#check?' do
    subject(:board_check) { described_class.new }

    before do
      knight = Knight.new('w', 5, 5)
      board_check.spaces[5][5] = knight
    end

    context 'when black is in check' do
      it 'returns true' do
        result = board_check.check?('b')
        expect(result).to be true
      end
    end

    context 'when white is not in check' do
      it 'returns false' do
        result = board_check.check?('w')
        expect(result).to be false
      end
    end
  end

  describe '#checkmate?' do
    subject(:board_checkmate) { described_class.new }

    before do
      board_checkmate.set_current_piece([4, 0])
      board_checkmate.move_current_piece([4, 1])
    end

    context 'when white king is in checkmate' do
      before do
        board_checkmate.spaces[4][5] = Queen.new('b', 4, 5)
        board_checkmate.spaces[3][5] = Rook.new('b', 3, 5)
        board_checkmate.spaces[5][5] = Rook.new('b', 5, 5)
      end

      it 'returns true' do
        result = board_checkmate.checkmate?('w')
        expect(result).to be true
      end
    end

    context 'when white is in check' do
      before do
        board_checkmate.spaces[4][5] = Queen.new('b', 4, 5)
      end
      it 'returns false' do
        result = board_checkmate.checkmate?('w')
        expect(result).to be false
      end
    end

    context 'when white king is not in checkmate or check' do
      it 'returns false' do
        result = board_checkmate.checkmate?('w')
        expect(result).to be false
      end
    end
  end

  describe '#stalemate?' do
    subject(:board_stalemate) { described_class.new }

    before do
      board_stalemate.spaces.map! do |col|
        col.map! do |piece|
          piece.instance_of?(King) ? piece : NoPiece.new(piece.x, piece.y)
        end
      end
      board_stalemate.set_current_piece([4, 0])
      board_stalemate.move_current_piece([6, 6])
    end

    context 'when black is not in check and has no legal moves left' do
      before do
        board_stalemate.spaces[3][5] = Queen.new('w', 3, 5)
      end

      it 'returns true' do
        result = board_stalemate.stalemate?('b')
        expect(result).to be true
      end
    end

    context 'when black has legal moves left' do
      before do
        board_stalemate.spaces[3][4] = Queen.new('w', 3, 4)
      end

      it 'returns false' do
        result = board_stalemate.stalemate?('b')
        expect(result).to be false
      end
    end
  end

  describe '#piece_has_move_to_remove_check?' do
    subject(:board) { described_class.new }

    before do
      board.spaces[4][2] = Queen.new('w', 4, 2)
      board.spaces[4][6] = NoPiece.new(4, 6)
    end

    context 'piece can remove check' do
      it 'returns true' do
        result = board.piece_has_move_to_remove_check?([3, 7])
        expect(result).to be true
      end
    end

    context 'piece cant remove check' do
      it 'returns false' do
        result = board.piece_has_move_to_remove_check?([4, 7])
        expect(result).to be false
      end
    end
  end

  describe '#hypothetical_move_causes_check?' do
    subject(:board) { described_class.new }

    before do
      board.spaces[7][4] = Queen.new('w', 7, 4)
    end

    context 'move causes a check' do
      it 'returns true' do
        result = board.hypothetical_move_causes_check?([5, 6], [5, 5], 'b')
        expect(result).to be true
      end
    end

    context 'move doesnt cause a check' do
      it 'returns false' do
        result = board.hypothetical_move_causes_check?([4, 6], [4, 5], 'b')
        expect(result).to be false
      end
    end
  end

  describe '#hypothetical_move_removes_check?' do
    subject(:board) { described_class.new }

    before do
      board.spaces[4][4] = Queen.new('w', 4, 4)
      board.spaces[7][4] = Rook.new('b', 7, 4)
      board.spaces[4][6] = NoPiece.new(4, 6)
      board.spaces[5][6] = NoPiece.new(5, 6)
    end

    context 'move removes a check' do
      context 'by capturing the piece causing check' do
        it 'returns true' do
          result = board.hypothetical_move_removes_check?([7, 4], [4, 4], 'b')
          expect(result).to be true
        end
      end

      context 'by blocking the movement of the piece casuing check' do
        it 'returns true' do
          result = board.hypothetical_move_removes_check?([5, 7], [4, 6], 'b')
          expect(result).to be true
        end
      end

      context 'by moving the king to a safe spot' do
        it 'returns true' do
          result = board.hypothetical_move_removes_check?([4, 7], [5, 6], 'b')
          expect(result).to be true
        end
      end
    end

    context 'move doesnt remove a check' do
      it 'returns false' do
        result = board.hypothetical_move_removes_check?([4, 7], [4, 6], 'b')
        expect(result).to be false
      end
    end
  end

  describe '#legal_move?' do
    subject(:board_legal) { described_class.new }

    context 'when move is possible for piece' do
      it 'returns true' do
        board_legal.set_current_piece([1, 0])
        result = board_legal.legal_move?([2, 2])
        expect(result).to be true
      end
    end

    context 'when move isnt possible for piece' do
      it 'returns false' do
        board_legal.set_current_piece([1, 0])
        result = board_legal.legal_move?([1, 2])
        expect(result).to be false
      end
    end

    context 'when move causes check' do
      before do
        board_legal.spaces[0][3] = Queen.new('w', 0, 3)
        board_legal.set_current_piece([3, 6])
      end

      it 'returns false' do
        result = board_legal.legal_move?([3, 5])
        expect(result).to be false
      end
    end

    context 'when king is in check' do
      before do
        board_legal.spaces[0][3] = Queen.new('w', 0, 3)
        board_legal.spaces[3][6] = NoPiece.new(3, 6)
        board_legal.set_current_piece([3, 7])
      end

      context 'and move removes check' do
        it 'returns true' do
          result = board_legal.legal_move?([3, 6])
          expect(result).to be true
        end
      end
      context 'and move deosnt remove check' do
        it 'returns false' do
          result = board_legal.legal_move?([3, 5])
          expect(result).to be false
        end
      end
    end
  end
end
