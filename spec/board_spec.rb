require_relative '../lib/board'
describe Board do
  describe '#initialize' do
    subject(:initialized_board) { described_class.new }
    context 'when board is initialized' do
      it 'is initialized with a 6x7 array' do
        result = initialized_board.instance_variable_get(:@board)
        expect(result).to eql(Array.new(6) { Array.new(7) })
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
      subject(:full_column_board) { described_class.new [%w[x x x x], %w[x x x x], %w[x x x x]] }
      it 'is an invalid move' do
        invalid_input = 2
        result = full_column_board.valid_move?(invalid_input)
        expect(result).to be false
      end
    end
  end
end
