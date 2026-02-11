require_relative '../lib/board'
describe Board do
  describe '#initialize' do
    subject(:initialized_board) { described_class.new }
    context 'when board is initialized' do
      it 'is initialized with a 6x7 array' do
        result = initialized_board.instance_variable_get(:@board)
        expect(result).to eql(Array.new(6) { Array.new(7) { '  ' } })
      end
    end
  end

  describe '#full?' do
    context 'when board is empty' do
      subject(:empty_board) { described_class.new }
      it 'returns false' do
        expect(empty_board).to_not be_full
      end
    end

    context 'when board is full' do
      subject(:full_board) { described_class.new([%w[x x x x], %w[x x x x]]) }
      it 'returns true' do
        expect(full_board).to be_full
      end
    end
  end

  describe '#valid_move?' do
    context 'when a move is between 0 and 6' do
      subject(:valid_move_board) { described_class.new }
      it 'is a valid move' do
        valid_input = 0
        result = valid_move_board.valid_move?(valid_input)
        expect(result).to be true
      end
    end

    context 'when a move is less than 1' do
      subject(:invalid_move_board) { described_class.new }
      it 'is an invalid move' do
        invalid_input = -1
        result = invalid_move_board.valid_move?(invalid_input)
        expect(result).to be false
      end
    end

    context 'when a move is more than 7' do
      subject(:invalid_move_board) { described_class.new }
      it 'is an invalid move' do
        invalid_input = 7
        result = invalid_move_board.valid_move?(invalid_input)
        expect(result).to be false
      end
    end

    context 'when a column is full' do
      subject(:full_column_board) do
        described_class.new [[nil, 'x', nil, nil], [nil, 'x', nil, nil], [nil, 'x', nil, nil]]
      end
      it 'is an invalid move' do
        invalid_input = 1
        result = full_column_board.valid_move?(invalid_input)
        expect(result).to be false
      end
    end
  end

  describe '#find_empty_cell_row' do
    context 'when board is empty' do
      subject(:empty_board) { described_class.new }

      it 'returns the row number with an empty cell within a column' do
        column = 2
        result = empty_board.find_empty_cell_row(column)
        expect(result).to eql 5
      end
    end

    context 'when column has occupied cells' do
      subject(:occupied_column_board) do
        described_class.new([['  ', '  ', '  '], ['  ', 'x', '  '], ['  ', 'x', '  ']])
      end

      it 'returns the next row number with an empty cell within a column' do
        column = 1
        result = occupied_column_board.find_empty_cell_row(column)
        expect(result).to eql 0
      end
    end
  end

  describe '#place_circle' do
    context 'when a circle is placed' do
      subject(:circle_board) { described_class.new }
      let(:player) { instance_double('Player') }
      before do
        allow(player).to receive(:circle).and_return("\u{1F535}")
      end
      it 'places a circle on the board' do
        move = 5
        expect { circle_board.place_circle(move, player) }.to(change { circle_board.instance_variable_get(:@board) })
      end
    end
  end

  describe '#winner?' do
    context 'when a player has 4 consecutive moves in a column' do
      subject(:columns_board) do
        described_class.new [[nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil],
                             ["\u{1F535}", nil, nil, nil, nil, nil, nil], ["\u{1F535}", nil, nil, nil, nil, nil, nil],
                             ["\u{1F535}", nil, nil, nil, nil, nil, nil], ["\u{1F535}", nil, nil, nil, nil, nil, nil]]
      end
      let(:player) { instance_double('Player') }
      before do
        allow(player).to receive(:circle).and_return("\u{1F535}")
      end

      context "when the player's move is [2, 0]" do
        it 'returns true' do
          move = [2, 0]
          result = columns_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [3, 0]" do
        it 'returns true' do
          move = [3, 0]
          result = columns_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [4, 0]" do
        it 'returns true' do
          move = [4, 0]
          result = columns_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [5, 0]" do
        it 'returns true' do
          move = [5, 0]
          result = columns_board.winner?(player, move)
          expect(result).to be true
        end
      end
      context "when the player's move is [1, 0]" do
        it 'does not return true' do
          move = [1, 0]
          result = columns_board.winner?(player, move)
          expect(result).to_not be true
        end
      end
    end

    context 'when a player has 4 consecutive moves in a row' do
      subject(:rows_board) do
        described_class.new [[nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil],
                             ["\u{1F535}", "\u{1F535}", "\u{1F535}", "\u{1F535}", nil, nil, nil]]
      end
      let(:player) { instance_double('Player') }
      before do
        allow(player).to receive(:circle).and_return("\u{1F535}")
      end

      context "when the player's move is [5, 0]" do
        it 'returns true' do
          move = [5, 0]
          result = rows_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [5, 1]" do
        it 'returns true' do
          move = [5, 1]
          result = rows_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [5, 2]" do
        it 'returns true' do
          move = [5, 2]
          result = rows_board.winner?(player, move)
          expect(result).to be true
        end
      end
      context "when the player's move is [5, 3]" do
        it 'returns true' do
          move = [5, 3]
          result = rows_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [5, 4]" do
        it 'does not return true' do
          move = [5, 4]
          result = rows_board.winner?(player, move)
          expect(result).to_not be true
        end
      end
    end

    context 'when a player has 4 consecutive diagonal moves bottom-right' do
      subject(:diagonals_board) do
        described_class.new [[nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, "\u{1F535}", nil, nil, nil],
                             [nil, nil, nil, nil, "\u{1F535}", nil, nil],
                             [nil, nil, nil, nil, nil, "\u{1F535}", nil],
                             [nil, nil, nil, nil, nil, nil, "\u{1F535}"]]
      end
      let(:player) { instance_double('Player') }
      before do
        allow(player).to receive(:circle).and_return("\u{1F535}")
      end

      context "when the player's move is [2, 3]" do
        it 'returns true' do
          move = [2, 3]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [3, 4]" do
        it 'returns true' do
          move = [3, 4]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end
      context "when the player's move is [4, 5]" do
        it 'returns true' do
          move = [4, 5]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [5, 6]" do
        it 'returns true' do
          move = [5, 6]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [1, 2]" do
        it 'does not return true' do
          move = [1, 2]
          result = diagonals_board.winner?(player, move)
          expect(result).to_not be true
        end
      end
    end

    context 'when a player has 4 consecutive diagonal moves bottom-left' do
      subject(:diagonals_board) do
        described_class.new [[nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, "\u{1F535}", nil, nil, nil],
                             [nil, nil, "\u{1F535}", nil, nil, nil, nil],
                             [nil, "\u{1F535}", nil, nil, nil, nil, nil],
                             ["\u{1F535}", nil, nil, nil, nil, nil, nil]]
      end
      let(:player) { instance_double('Player') }
      before do
        allow(player).to receive(:circle).and_return("\u{1F535}")
      end

      context "when the player's move is [2, 3]" do
        it 'returns true' do
          move = [2, 3]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [3, 2]" do
        it 'returns true' do
          move = [3, 2]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end
      context "when the player's move is [4, 1]" do
        it 'returns true' do
          move = [4, 1]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [5, 0]" do
        it 'returns true' do
          move = [5, 0]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [1, 2]" do
        it 'does not return true' do
          move = [1, 2]
          result = diagonals_board.winner?(player, move)
          expect(result).to_not be true
        end
      end
    end

    context 'when a player has 4 consecutive diagonal moves top-left' do
      subject(:diagonals_board) do
        described_class.new [["\u{1F535}", nil, nil, nil, nil, nil, nil],
                             [nil, "\u{1F535}", nil, nil, nil, nil, nil],
                             [nil, nil, "\u{1F535}", nil, nil, nil, nil],
                             [nil, nil, nil, "\u{1F535}", nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil]]
      end
      let(:player) { instance_double('Player') }
      before do
        allow(player).to receive(:circle).and_return("\u{1F535}")
      end

      context "when the player's move is [3, 3]" do
        it 'returns true' do
          move = [3, 3]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [2, 2]" do
        it 'returns true' do
          move = [2, 2]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end
      context "when the player's move is [1, 1]" do
        it 'returns true' do
          move = [1, 1]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [0, 0]" do
        it 'returns true' do
          move = [0, 0]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [1, 2]" do
        it 'does not return true' do
          move = [4, 4]
          result = diagonals_board.winner?(player, move)
          expect(result).to_not be true
        end
      end
    end

    context 'when a player has 4 consecutive diagonal moves top-right' do
      subject(:diagonals_board) do
        described_class.new [[nil, nil, nil, nil, nil, nil, "\u{1F535}"],
                             [nil, nil, nil, nil, nil, "\u{1F535}", nil],
                             [nil, nil, nil, nil, "\u{1F535}", nil, nil],
                             [nil, nil, nil, "\u{1F535}", nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil]]
      end
      let(:player) { instance_double('Player') }
      before do
        allow(player).to receive(:circle).and_return("\u{1F535}")
      end

      context "when the player's move is [3, 3]" do
        it 'returns true' do
          move = [3, 3]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [2, 4]" do
        it 'returns true' do
          move = [2, 4]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end
      context "when the player's move is [1, 5]" do
        it 'returns true' do
          move = [1, 5]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [0, 6]" do
        it 'returns true' do
          move = [0, 6]
          result = diagonals_board.winner?(player, move)
          expect(result).to be true
        end
      end

      context "when the player's move is [3, 4]" do
        it 'does not return true' do
          move = [3, 4]
          result = diagonals_board.winner?(player, move)
          expect(result).to_not be true
        end
      end
    end

    context 'when no player has 4 consecutive move in a row' do
      subject(:row_board) do
        described_class.new [[nil, nil, nil, nil, "\u{1F535}", "\u{1F535}", "\u{1F535}"],
                             [nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil]]
      end
      let(:player) { instance_double('Player') }
      before do
        allow(player).to receive(:circle).and_return("\u{1F535}")
      end

      it 'returns false' do
        move = [0, 4]
        result = row_board.winner?(player, move)
        expect(result).to be false
      end

      context 'when move is [0, 5]' do
        it 'returns false' do
          move = [0, 5]
          result = row_board.winner?(player, move)
          expect(result).to be false
        end
      end

      context 'when move is [0, 6]' do
        it 'returns false' do
          move = [0, 6]
          result = row_board.winner?(player, move)
          expect(result).to be false
        end
      end

      context 'when no player has 4 consecutive move in a column' do
        subject(:column_board) do
          described_class.new [[nil, nil, nil, nil, nil, nil, nil],
                               [nil, nil, nil, nil, nil, nil, nil],
                               [nil, nil, nil, nil, nil, nil, nil],
                               ["\u{1F535}", nil, nil, nil, nil, nil, nil],
                               ["\u{1F535}", nil, nil, nil, nil, nil, nil],
                               ["\u{1F535}", nil, nil, nil, nil, nil, nil]]
        end
        let(:player) { instance_double('Player') }
        before do
          allow(player).to receive(:circle).and_return("\u{1F535}")
        end

        it 'returns false' do
          move = [3, 0]
          result = column_board.winner?(player, move)
          expect(result).to be false
        end

        context 'when move is [3, 4]' do
          it 'returns false' do
            move = [3, 4]
            result = column_board.winner?(player, move)
            expect(result).to be false
          end
        end

        context 'when move is [3, 5]' do
          it 'returns false' do
            move = [3, 5]
            result = column_board.winner?(player, move)
            expect(result).to be false
          end
        end
      end

      context 'when no player has 4 consecutive move in a diagonal' do
        subject(:diagonals_board) do
          described_class.new [[nil, nil, nil, nil, nil, nil, nil],
                               [nil, nil, nil, nil, nil, nil, nil],
                               [nil, nil, nil, nil, nil, nil, nil],
                               [nil, nil, "\u{1F535}", nil, nil, nil, nil],
                               [nil, "\u{1F535}", nil, nil, nil, nil, nil],
                               ["\u{1F535}", nil, nil, nil, nil, nil, nil]]
        end
        let(:player) { instance_double('Player') }
        before do
          allow(player).to receive(:circle).and_return("\u{1F535}")
        end

        it 'returns false' do
          move = [5, 0]
          result = diagonals_board.winner?(player, move)
          expect(result).to be false
        end

        context 'when move is [4, 1]' do
          it 'returns false' do
            move = [4, 1]
            result = diagonals_board.winner?(player, move)
            expect(result).to be false
          end
        end

        context 'when move is [3, 2]' do
          it 'returns false' do
            move = [3, 2]
            result = diagonals_board.winner?(player, move)
            expect(result).to be false
          end
        end
      end
    end
  end
end
