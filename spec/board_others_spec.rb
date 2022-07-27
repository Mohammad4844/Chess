require_relative '../lib/board'

describe Board do
  describe '#check?' do
    context 'when black is in check' do
      xit 'returns true' do
      end
    end

    context 'when white is not in check' do
      xit 'returns false' do
      end
    end
  end

  describe '#checkmate?' do
    context 'when white king is in checkmate' do
      xit 'returns true' do
      end
    end

    context 'when white is in check' do
      xit 'returns false' do
      end
    end

    context 'when white king is not in checkmate' do
      xit 'returns false' do
      end
    end
  end

  describe '#stalemate?' do
    context 'when black has no legal moves left' do
      xit 'returns true' do
      end
    end

    context 'when black has legal moves left' do
      xit 'returns false' do
      end
    end
  end

  describe '#piece_has_move_to_remove_check?' do
    context 'piece can remove check' do
      xit 'returns true' do
      end
    end

    context 'piece cant remove check' do
      xit 'returns false' do
      end
    end
  end

  describe '#hypothetical_move_causes_check?' do
    context 'move causes a check' do
      xit 'returns true' do
      end
    end

    context 'move doesnt cause a check' do
      xit 'returns false' do
      end
    end
  end

  describe '#hypothetical_move_removes_check?' do
    context 'move removes a check' do
      xit 'returns true' do
      end
    end

    context 'move doesnt remove a check' do
      xit 'returns false' do
      end
    end
  end

  describe '#legal_move?' do
    context 'when move is possible for piece and doesnt cause check' do
      xit 'returns true' do
      end
    end

    context 'when move puts king in check' do
      xit 'returns false' do
      end
    end

    context 'when move isnt possible for piece' do
      xit 'returns false' do
      end
    end

    context 'when king is in check' do
      context 'and move removes check' do
        xit 'returns true' do
        end
      end
      context 'and move deosnt remove check' do
        xit 'returns false' do
        end
      end
    end
  end
end