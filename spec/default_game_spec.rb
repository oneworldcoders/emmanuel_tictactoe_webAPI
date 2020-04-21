RSpec.describe DefaultGame do
  context 'Load data' do
    before(:each) do
      @default_game = DefaultGame.new
      @game_id = 1
    end

    it 'returns default empty state when not defined' do
      expected_result = ['', '', '', '', '', '', '', '', '']
      expect(@default_game.state).to eq(expected_result)
    end

    it 'returns default turn X when not defined' do
      expected_result = 'X'
      expect(@default_game.turn).to eq(expected_result)
    end
  end
end
