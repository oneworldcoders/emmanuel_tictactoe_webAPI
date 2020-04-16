require 'rspec'
require 'datastore'

describe Datastore do
  include_examples 'datastore interface'

  context 'load all' do
    it 'returns empty for new store' do
      datastore = Datastore.new
      expect(datastore.load_all).to eq({})
    end

    it 'creates 1 existing record' do
      data = { 1 => { state: [] } }
      datastore = Datastore.new(data)
      expect(datastore.load_all).to eq(data)
    end

    it 'creates multiple existing records' do
      data = {
        1 => { state: [] },
        2 => { state: ['X'] }
      }
      datastore = Datastore.new(data)
      expect(datastore.load_all).to eq(data)
    end
  end
end

describe 'Datastore' do
  context 'load' do
    it 'returns default null state when nil' do
      datastore = Datastore.new
      expected_state = ['', '', '', '', '', '', '', '', '']
      expect(datastore.load(1, :state)).to eq(expected_state)
    end

    it 'returns default null turn when nil' do
      datastore = Datastore.new
      expected_turn = 'X'
      expect(datastore.load(2, :turn)).to eq(expected_turn)
    end

    it 'returns current state' do
      data = { 1 => { state: [] } }
      datastore = Datastore.new(data)
      expected_state = []
      expect(datastore.load(1, :state)).to eq(expected_state)
    end

    it 'returns current turn' do
      data = { 1 => { turn: 'O' } }
      datastore = Datastore.new(data)
      expected_turn = 'O'
      expect(datastore.load(1, :turn)).to eq(expected_turn)
    end
  end
end

describe 'Datastore' do
  context 'store' do
    before(:each) do
      @data1 = { state: [], turn: 'O' }
      @data2 = { state: ['X'], turn: 'X' }
      @datastore = Datastore.new
      @datastore.store(1, @data1)
      @datastore.store(2, @data2)
    end
    it 'adds a single entry' do
      expected_turn = 'O'
      expected_state = []
      expect(@datastore.load(1, :turn)).to eq(expected_turn)
      expect(@datastore.load(1, :state)).to eq(expected_state)
    end

    it 'adds multiple entries' do
      expected_turn1 = 'O'
      expected_turn2 = 'X'
      expected_state1 = []
      expected_state2 = ['X']

      expect(@datastore.load(1, :turn)).to eq(expected_turn1)
      expect(@datastore.load(1, :state)).to eq(expected_state1)
      expect(@datastore.load(2, :turn)).to eq(expected_turn2)
      expect(@datastore.load(2, :state)).to eq(expected_state2)
    end
  end
end

describe 'Datastore' do
  context 'has key' do
    it 'returns true if game_id exists' do
      data = { 1 => { state: [] } }
      datastore = Datastore.new(data)
      expect(datastore.key?(1)).to be true
    end

    it "returns false if game_id donesn't exists" do
      datastore = Datastore.new
      expect(datastore.key?(1)).to be false
    end
  end
end

describe 'Datastore' do
  context 'clear' do
    it 'empties the datastore' do
      data = { 1 => { state: [] } }
      datastore = Datastore.new(data)
      expect(datastore.key?(1)).to be true

      datastore.clear
      expect(datastore.key?(1)).to be false
    end
  end
end
