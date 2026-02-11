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
        create_name_msg = "Enter player 1's name with at least one character: "
        expect(Player).to receive(:new).with('Reyad'.blue, "\u{1F535}")
        expect(create_game).to receive(:puts).with(create_name_msg)
        create_game.create_player("\u{1F535}", 1, :blue)
      end
    end
  end

  describe '#player_input' do
    let(:player) { instance_double('Player') }
    let(:board) { instance_double('Board') }
    subject(:input_game) { described_class.new(board, player, player) }

    context 'when input is valid' do
      before do
        allow(player).to receive(:move).and_return(6)
        allow(board).to receive(:valid_move?).and_return(true)
        allow(player).to receive(:name).and_return('name')
      end
      it 'returns player input' do
        result = input_game.player_input
        expect(result).to eq 6
      end
    end

    context 'when input is invalid' do
      before do
        allow(player).to receive(:move).and_return(7)
        allow(player).to receive(:name).and_return('name')
        allow(board).to receive(:valid_move?).and_return(false, true)
      end
      it 'returns error msg' do
        error_msg = '=> Invalid input, please try again!'.red
        expect(input_game).to receive(:puts).with(error_msg).once
        input_game.player_input
      end
    end
  end

  describe '#switch_player' do
    subject(:switch_game) { described_class.new('board', 'player1', 'player2') }
    context 'when current player is player1' do
      before do
        allow(switch_game).to receive(:players).and_return(%w[player1 player2])
        switch_game.instance_variable_set(:@current_player, 'player1')
      end
      it 'changes current player to player2' do
        expect { switch_game.switch_player }.to change {
          switch_game.instance_variable_get(:@current_player)
        }.to 'player2'
      end
    end

    context 'when current player is player2' do
      before do
        allow(switch_game).to receive(:players).and_return(%w[player2 player1])
        switch_game.instance_variable_set(:@current_player, 'player2')
      end
      it 'changes current player to player1' do
        expect { switch_game.switch_player }.to change {
          switch_game.instance_variable_get(:@current_player)
        }.to 'player1'
      end
    end
  end

  describe '#game_over?' do
    let(:board) { instance_double('Board') }
    subject(:game_over) { described_class.new(board, 'player', 'player2') }
    context 'when board is full' do
      before do
        allow(board).to receive(:winner?).and_return false
        allow(board).to receive(:full?).and_return true
      end
      it 'returns true' do
        expect(game_over).to be_game_over
      end
    end

    context 'when there is a winner' do
      before do
        allow(board).to receive(:winner?).and_return true
      end
      it 'returns true' do
        expect(game_over).to be_game_over
      end
    end
  end
end
