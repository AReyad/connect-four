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
    context 'when a move is between 1 and 7' do
      subject(:valid_move_board) { described_class.new }
      it 'is a valid move' do
        valid_input = 1
        result = valid_move_board.valid_move?(valid_input)
        expect(result).to be true
      end
    end

    context 'when a move is less than 1' do
      subject(:invalid_move_board) { described_class.new }
      it 'is an invalid move' do
        invalid_input = 0
        result = invalid_move_board.valid_move?(invalid_input)
        expect(result).to be false
      end
    end

    context 'when a move is more than 7' do
      subject(:invalid_move_board) { described_class.new }
      it 'is an invalid move' do
        invalid_input = 8
        result = invalid_move_board.valid_move?(invalid_input)
        expect(result).to be false
      end
    end

    context 'when a column is full' do
      subject(:full_column_board) do
        described_class.new [[nil, 'x', nil, nil], [nil, 'x', nil, nil], [nil, 'x', nil, nil]]
      end
      it 'is an invalid move' do
        invalid_input = 2
        result = full_column_board.valid_move?(invalid_input)
        expect(result).to be false
      end
    end
  end
  def four_connected?(arr)
    arr.each_cons(4).any? do |seq|
      seq.all? { |element| element == seq.first }
    end
  end

  describe '#find_empty_cell_row' do
    context 'when board is empty' do
      subject(:empty_board) { described_class.new }

      it 'returns the row number with an empty cell within a column' do
        move = 2
        column = move - 1 # move - 1 to convert a move which starts at 1 to an array index
        result = empty_board.find_empty_cell_row(column)
        expect(result).to eql 5
      end
    end

    context 'when column has occupied cells' do
      subject(:occupied_column_board) do
        described_class.new([['  ', '  ', '  '], ['  ', 'x', '  '], ['  ', 'x', '  ']])
      end

      it 'returns the next row number with an empty cell within a column' do
        move = 2
        column = move - 1
        result = occupied_column_board.find_empty_cell_row(column)
        expect(result).to eql 0
      end
    end
  end

  describe '#assign_move' do
    context 'when a move is assigned' do
      subject(:assign_board) { described_class.new }
      let(:player) { instance_double('Player') }
      before do
        allow(player).to receive(:circle).and_return("\u{1F535}")
      end
      it 'places a circle on the board' do
        move = 5
        expect { assign_board.assign_move(move, player) }.to(change { assign_board.instance_variable_get(:@board) })
      end
    end
  end

  describe '#board_winner?' do
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

      it 'returns true' do
        move = [2, 0]
        result = columns_board.board_winner?(player, move)
        expect(result).to be true
      end
    end

    context 'when a player has 4 consecutive moves in a row' do
      subject(:rows_board) do
        described_class.new [[nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil],
                             ["\u{1F535}", "\u{1F535}", "\u{1F535}", "\u{1F535}", nil, nil, nil]]
      end
      let(:player) { instance_double('Player') }
      before do
        allow(player).to receive(:circle).and_return("\u{1F535}")
      end

      it 'returns true' do
        move = [5, 3]
        result = rows_board.board_winner?(player, move)
        expect(result).to be true
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

      it 'returns true' do
        move = [2, 3]
        result = diagonals_board.board_winner?(player, move)
        expect(result).to be true
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

      it 'returns true' do
        move = [2, 3]
        result = diagonals_board.board_winner?(player, move)
        expect(result).to be true
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

      it 'returns true' do
        move = [3, 3]
        result = diagonals_board.board_winner?(player, move)
        expect(result).to be true
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

      it 'returns true' do
        move = [3, 3]
        result = diagonals_board.board_winner?(player, move)
        expect(result).to be true
      end
    end
  end
end
