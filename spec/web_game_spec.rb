require 'rspec'
require 'web_game'
require 'fake_datastore'

describe 'WebGame' do
  context 'Loading game state' do
    it 'loads empty game from datastore' do
      fake_datastore = FakeDatastore.new
      web_game = WebGame.new(fake_datastore)

      expect(web_game.load_state(1)).to eq([])
    end

    it 'loads empty state current game from datastore' do
      data = { 1 => { state: [] } }
      fake_datastore = FakeDatastore.new(data)
      web_game = WebGame.new(fake_datastore)

      expect(web_game.load_state(1)).to eq(data.dig(1, :state))
    end

    it 'loads filled in state for current game from datastore' do
      data = { 1 => { state: [1, 2] } }
      fake_datastore = FakeDatastore.new(data)
      web_game = WebGame.new(fake_datastore)

      expect(web_game.load_state(1)).to eq(data.dig(1, :state))
    end

    it 'loads all games from datastore' do
      data = { 1 => { state: [1, 2] } }
      fake_datastore = FakeDatastore.new(data)
      web_game = WebGame.new(fake_datastore)

      expect(web_game.load_all).to eq(data)
    end
  end
end

describe 'WebGame' do
  context 'Loading turn' do
    it 'loads X for empty datastore' do
      fake_datastore = FakeDatastore.new
      web_game = WebGame.new(fake_datastore)

      expect(web_game.load_turn(1)).to eq('X')
    end

    it 'loads O for current game from datastore' do
      data = { 1 => { turn: 'O' } }
      fake_datastore = FakeDatastore.new(data)
      web_game = WebGame.new(fake_datastore)

      expect(web_game.load_turn(1)).to eq(data.dig(1, :turn))
    end
  end

  context 'store game' do
    it 'store the game data in the datastore' do
      fake_datastore = FakeDatastore.new
      web_game = WebGame.new(fake_datastore)

      data = { 1 => { state: [1, 2], turn: 'X' } }
      web_game.store(data)

      expect(web_game.load_state(1)).to eq(data.dig(1, :state))
      expect(web_game.load_turn(1)).to eq(data.dig(1, :turn))
    end
  end
end
