require_relative '../lib/player'

describe Player do
  describe '#initialize' do
    subject(:new_player) { described_class.new('Reyad', 'O') }
    context 'when a player is initialized' do
      it 'is initialized with a name' do
        player_name = new_player.instance_variable_get(:@name)
        expect(player_name).to_not be nil
      end

      it 'is initialized with a circle' do
        player_circle = new_player.instance_variable_get(:@circle)
        expect(player_circle).to_not be nil
      end
    end
  end
end
