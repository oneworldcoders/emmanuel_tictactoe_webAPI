require_relative '../models/game'

describe PGDatabase do
  include_examples 'datastore interface'

  DatabaseCleaner.strategy = :truncation

  before(:each) do
    @pg_database = PGDatabase.new
  end

  after(:each) do
    DatabaseCleaner.clean
  end

  context '#store' do
    it 'save game to database' do
      result = @pg_database.store(1, { 'state': [], 'turn': 'X' })
      expected = true
      expect(result).to eq(expected)
    end
  end

  context '#load_game' do
    it 'loads the game from database' do
      data = { 'game_id': 0, 'state': [''], 'turn': 'X' }
      expected = { state: [''], turn: 'X' }
      Game.new(data).save
      result = @pg_database.load_game(0)
      expect(result).to eq(expected)
    end

    it 'loads default game from database' do
      result = @pg_database.load_game(3)
      expected = { state: ['', '', '', '', '', '', '', '', ''], turn: 'X' }
      expect(result).to eq(expected)
    end
  end

  context '#has_key' do
    it 'checks for available key in database' do
      data = { 'game_id': 1 }
      Game.new(data).save
      result = @pg_database.key?(1)
      expected = true
      expect(result).to eq(expected)
    end

    it 'checks for unavailable key in database' do
      result = @pg_database.key?(0)
      expected = false
      expect(result).to eq(expected)
    end
  end

  context 'load' do
    it 'returns state' do
      data = { game_id: 0, state: [''] }
      Game.new(data).save
      expected_state = ['']
      result = @pg_database.load(0, :state)
      expect(result).to eq(expected_state)
    end

    it 'returns default state' do
      expected_state = ['', '', '', '', '', '', '', '', '']
      result = @pg_database.load(0, :state)
      expect(result).to eq(expected_state)
    end

    it 'returns current turn' do
      expected_turn = 'X'
      result = @pg_database.load(1, :turn)
      expect(result).to eq(expected_turn)
    end
  end

  context 'load all' do
    it 'returns the data in the database' do
      data1 = { 'game_id': '1', 'state': [''], 'turn': 'X' }
      data2 = { 'game_id': '2', 'state': [''], 'turn': 'X' }
      Game.new(data1).save
      Game.new(data2).save
      result = @pg_database.load_all
      expected = {
        '1' => { 'state': [''], 'turn': 'X' },
        '2' => { 'state': [''], 'turn': 'X' }
      }
      expect(result).to eq(expected)
    end
  end

  context '#clear' do
    xit 'deletes all records in database' do
      result = @pg_database.clear
      expected = true
      expect(result).to eq(expected)
    end
  end
end
