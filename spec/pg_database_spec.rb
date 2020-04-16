require 'rspec'
require 'pg_database'
require 'fake_pg_database'

describe PGDatabase do
  include_examples 'datastore interface'

  before(:each) do
    @pg_database2 = PGDatabase.new(FakePGDatabase.new)
  end

  context '#store' do
    it 'save game to database' do
      result = @pg_database2.store(1, { 'state': [], 'turn': 'X' })
      expected = true
      expect(result).to eq(expected)
    end
  end

  context '#load_game' do
    it 'loads the game from database' do
      result = @pg_database2.load_game(1)
      expected = { 'state': [''], 'turn': 'X' }
      expect(result).to eq(expected)
    end

    it 'loads default game from database' do
      result = @pg_database2.load_game(0)
      expected = { 'state': ['', '', '', '', '', '', '', '', ''], 'turn': 'X' }
      expect(result).to eq(expected)
    end
  end

  context '#has_key' do
    it 'checks for available key in database' do
      result = @pg_database2.key?(1)
      expected = true
      expect(result).to eq(expected)
    end

    it 'checks for unavailable key in database' do
      result = @pg_database2.key?(0)
      expected = false
      expect(result).to eq(expected)
    end
  end

  context 'load' do
    it 'returns state' do
      expected_state = ['']
      result = @pg_database2.load(1, :state)
      expect(result).to eq(expected_state)
    end

    it 'returns default state' do
      expected_state = ['', '', '', '', '', '', '', '', '']
      result = @pg_database2.load(0, :state)
      expect(result).to eq(expected_state)
    end

    it 'returns current turn' do
      expected_turn = 'X'
      result = @pg_database2.load(1, :turn)
      expect(result).to eq(expected_turn)
    end
  end

  context 'load all' do
    it 'returns the data in the database' do
      result = @pg_database2.load_all
      expected = { 1 => { 'state' => [''], 'turn' => 'X' } }
      expect(result).to eq(expected)
    end
  end

  context '#clear' do
    xit 'deletes all records in database' do
      result = @pg_database2.clear
      expected = true
      expect(result).to eq(expected)
    end
  end
end
