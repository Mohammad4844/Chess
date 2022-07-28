require_relative '../lib/board'

describe Board do
  describe '#regular_move' do
    subject(:board_regular) { described_class.new }

    before do
      board_regular.set_current_piece([0, 0])
    end
    it 'piece is on new space' do
      no_piece = NoPiece.new(3, 4)
      w_rook = Rook.new('w', 3, 4)
      expect { board_regular.regular_move([3, 4]) }.to \
        change { board_regular.piece_at([3, 4]) }.from(no_piece).to(w_rook)
    end
    it 'previous space is empty' do
      no_piece = NoPiece.new(0, 0)
      w_rook = Rook.new('w', 0, 0)
      expect { board_regular.regular_move([3, 4]) }.to \
        change { board_regular.piece_at([0, 0]) }.from(w_rook).to(no_piece)
    end
    it 'changes the x and y cooridnates of the piece' do
      position = [3, 4]
      board_regular.regular_move(position)
      piece = board_regular.piece_at(position)
      expect([piece.x, piece.y]).to eq(position)
    end
  end

  describe '#en_passant_position?' do
    subject(:board_en_passant) { described_class.new }

    context 'when enemy pawn is beside my pawn' do
      context 'and diagonal is empty' do
        before do
          board_en_passant.spaces[3][3] = Pawn.new('w', 3, 3)
          board_en_passant.spaces[4][3] = Pawn.new('b', 4, 3)
          board_en_passant.set_current_piece([3, 3])
        end

        it 'returns true' do
          result = board_en_passant.en_passant_position?([4, 4])
          expect(result).to be true
        end
      end

      context 'but diagonal has enemy piece' do
        before do
          board_en_passant.spaces[3][3] = Pawn.new('w', 3, 3)
          board_en_passant.spaces[4][3] = Pawn.new('b', 4, 3)
          board_en_passant.spaces[4][4] = Rook.new('b', 4, 4)
          board_en_passant.set_current_piece([3, 3])
        end

        it 'returns false' do
          result = board_en_passant.en_passant_position?([4, 4])
          expect(result).to be false
        end
      end
    end

    context "when enemy pawn is on my pawn's diagonal" do
      before do
        board_en_passant.spaces[3][3] = Pawn.new('w', 3, 3)
        board_en_passant.spaces[4][4] = Pawn.new('b', 4, 4)
        board_en_passant.set_current_piece([3, 3])
      end

      it 'returns false' do
        result = board_en_passant.en_passant_position?([4, 4])
        expect(result).to be false
      end
    end
  end

  describe '#en_passant_move' do
    subject(:board_en_passant) { described_class.new }

    before do
      board_en_passant.spaces[3][3] = Pawn.new('w', 3, 3)
      board_en_passant.spaces[4][3] = Pawn.new('b', 4, 3)
      board_en_passant.set_current_piece([3, 3])
    end

    it 'moves pawn to diagonal space' do
      w_pawn = Pawn.new('w', 4, 4)
      expect { board_en_passant.en_passant_move([4, 4]) }.to \
        change { board_en_passant.piece_at([4, 4]) }.to(w_pawn)
    end
    it 'captures the pawn to its side in passing' do
      no_piece = NoPiece.new(4, 3)
      expect { board_en_passant.en_passant_move([4, 4]) }.to \
        change { board_en_passant.piece_at([4, 3]) }.to(no_piece)
    end
  end

  describe '#any_pawn_promotable?' do
    subject(:board_promote) { described_class.new }

    context 'when black has one pawn on the last rank' do
      before do
        board_promote.spaces[0][0] = Pawn.new('b', 0, 0)
      end
      it 'returns true' do
        result = board_promote.any_pawn_promotable?('b')
        expect(result).to be true
      end
    end

    context 'when black has no pawn on the last rank' do
      it 'returns false' do
        result = board_promote.any_pawn_promotable?('b')
        expect(result).to be false
      end
    end
  end

  describe '#promote' do
    subject(:board_promote) { described_class.new }

    before do
      board_promote.spaces[0][0] = Pawn.new('b', 0, 0)
    end

    it 'promotes only the pawn on the last rank' do
      b_queen = Queen.new('b', 0, 0)
      expect { board_promote.promote('b', 'Queen') }.to \
        change { board_promote.spaces[0][0] }.to(b_queen)
    end
  end
end
