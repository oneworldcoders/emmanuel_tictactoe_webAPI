class FakeModel
  attr_reader :state, :turn
  def initialize(state = nil, turn = nil)
    @state = state
    @turn = turn
  end
end

describe GameSerializer do
  it 'serializes the model' do
    game_serializer = GameSerializer.new
    result = game_serializer.serialize(FakeModel.new([], 'X'))
    expected = { state: [], turn: 'X' }
    expect(result).to eq(expected)
  end

  it 'serializes the model with default data' do
    game_serializer = GameSerializer.new
    result = game_serializer.serialize(nil)
    expected = { state: ['', '', '', '', '', '', '', '', ''], turn: 'X' }
    expect(result).to eq(expected)
  end
end
