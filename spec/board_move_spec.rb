require_relative '../lib/board'

describe Board do
  describe '#regular_move' do
    xit 'changes the location of the piece' do
    end
    xit 'changes the x and y cooridnates of the piece' do
    end
  end

  describe '#en_passant_move?' do
    context 'if the move is an en passant move' do
      xit 'returns true' do
      end
    end
    context 'if the move is not an en passant move' do
      xit 'returns false' do
      end
    end
  end

  describe '#en_passant_move' do
    xit 'moves pawn to diagonal space' do
    end
    xit 'captures the pawn to its side in passing' do
    end
  end

  describe '#any_pawn_promotable?' do
    context 'when black has one pawn on the last rank' do
      xit 'returns true' do
      end
    end

    context 'when black has no pawn on the last rank' do
      xit 'returns false' do
      end
    end
  end

  describe '#promote' do
    xit 'promotes only the pawn on the last rank' do
    end
    xit 'promotes to Rook' do
    end
    xit 'promotes to Bishop' do
    end
    xit 'promotes to Knight' do
    end
    xit 'promotes to Queen' do
    end
  end
end