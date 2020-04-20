require_relative 'fake_datastore'
require_relative 'fake_uuid'
require_relative 'fakegame'

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
  context '#startGame' do
    it 'should be able to generate a new id when  #start_game is called' do
      fake_datastore = FakeDatastore.new
      web_game = WebGame.new(
        fake_datastore,
        FakeGame.new,
        TicTacToe::Turn.new,
        FakeUUID.new
      )
      web_game.start_game
      expect(fake_datastore.load_all.keys).to include('123ert567')
    end
  end

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
  context 'get_winner' do
    it 'should return false if we dont have a win' do
      fake_datastore = FakeDatastore.new
      web_game = WebGame.new(fake_datastore)
      expect(web_game.get_winner(1)).to eq(nil)
    end
    it 'should return a player if we have a win' do
      fake_datastore = FakeDatastore.new
      fakegame = FakeGame.new
      web_game = WebGame.new(fake_datastore,
                             fakegame, TicTacToe::Turn.new,
                             FakeUUID.new)
      expect(web_game.get_winner(1)).to eq(1)
    end
  end
end
