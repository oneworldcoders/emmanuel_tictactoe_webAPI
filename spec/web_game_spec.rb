require "rspec"
require "web_game"
require "fake_datastore"
require "fake_uuid"
require "fakegame"

describe "WebGame" do
  context "Loading game state" do
    it "loads empty game from datastore" do
      fake_datastore = FakeDatastore.new
      web_game = WebGame.new(fake_datastore)

      expect(web_game.load_state(1)).to eq([])
    end

    it "loads empty state current game from datastore" do
      data = { 1 => { state: [] } }
      fake_datastore = FakeDatastore.new(data)
      web_game = WebGame.new(fake_datastore)

      expect(web_game.load_state(1)).to eq(data.dig(1, :state))
    end

    it "loads filled in state for current game from datastore" do
      data = { 1 => { state: [1, 2] } }
      fake_datastore = FakeDatastore.new(data)
      web_game = WebGame.new(fake_datastore)

      expect(web_game.load_state(1)).to eq(data.dig(1, :state))
    end

    it "loads all games from datastore" do
      data = { 1 => { state: [1, 2] } }
      fake_datastore = FakeDatastore.new(data)
      web_game = WebGame.new(fake_datastore)

      expect(web_game.load_all).to eq(data)
    end
  end
  context "#startGame" do
    it "should be able to generate a new id when  #start_game is called" do
      fake_datastore = FakeDatastore.new
      web_game = WebGame.new(fake_datastore, game = nil, turn = nil, uuid = FakeUUID.new)
      web_game.start_game
      expect(fake_datastore.load_all.keys).to include("123ert567")
    end
  end

  context "Loading turn" do
    it "loads X for empty datastore" do
      fake_datastore = FakeDatastore.new
      web_game = WebGame.new(fake_datastore)

      expect(web_game.load_turn(1)).to eq("X")
    end

    it "loads O for current game from datastore" do
      data = { 1 => { turn: "O" } }
      fake_datastore = FakeDatastore.new(data)
      web_game = WebGame.new(fake_datastore)

      expect(web_game.load_turn(1)).to eq(data.dig(1, :turn))
    end
  end

  context "store game" do
    it "store the game data in the datastore" do
      fake_datastore = FakeDatastore.new
      web_game = WebGame.new(fake_datastore)

      data = { 1 => { state: [1, 2], turn: "X" } }
      web_game.store(data)

      expect(web_game.load_state(1)).to eq(data.dig(1, :state))
      expect(web_game.load_turn(1)).to eq(data.dig(1, :turn))
    end
  end
  context "check_win" do
    it "should return false if we dont have a win" do
      fake_datastore = FakeDatastore.new
      web_game = WebGame.new(fake_datastore)
      expect(web_game.check_win(1,1)).to eq(false)
    end
    it "should return a player if we have a win" do
      fake_datastore = FakeDatastore.new
      fakegame=FakeGame.new
      web_game = WebGame.new(fake_datastore,fakegame,nil,nil)
      expect(web_game.check_win(1,1)).to eq(1)
    end
  end
end
