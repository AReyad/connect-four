require_relative '../lib/game'
describe Game do
  describe '#initialize' do
    context 'when initialized' do
      let(:board) { double('Board') }
      let(:player) { double('Player') }
      subject(:initialized_game) { described_class.new(board.new, player.new, player.new) }

      before do
        allow(board).to receive(:new).and_return([])
        allow(player).to receive(:new).and_return('Player')
      end

      it 'is initialized with a board' do
        board = initialized_game.instance_variable_get(:@board)
        expect(board).to_not be nil
      end
      it 'is initialized with two players' do
        player1 = initialized_game.instance_variable_get(:@player1)
        player2 = initialized_game.instance_variable_get(:@player2)
        expect(player1).to_not be nil
        expect(player2).to_not be nil
      end
    end
  end

  describe '#create_player' do
    let(:player) { double('Player') }
    let(:board) { double('Board') }
    subject(:create_game) { described_class.new(board, player, player) }

    context 'when a player is created' do
      before do
        allow(create_game).to receive(:gets).and_return('Reyad')
        allow(player).to receive(:name).and_return('R')
      end

      it 'sends a msg to player class' do
        expect(Player).to receive(:new).with('Reyad'.blue, "\u{1F535}")
        create_game.create_player("\u{1F535}", 1, :blue)
      end
    end
  end
end
