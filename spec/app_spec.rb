require 'app'
require 'datastore'
require 'fake_turn'
require 'fake_output'

require 'rack/test'
require 'rspec'


RSpec.describe 'The App' do
  include Rack::Test::Methods

  def app
    App.new(nil, @datastore, FakeTurn.new)
  end

  before(:each) do
    @game_id = 0
    @datastore = Datastore.new
    @request_headers = { 'CONTENT_TYPE' => 'application/json' }
  end

  after(:each) do
    @datastore.clear
  end

  context "Available moves" do
    
    it "should return array of 1 to 9 for new game" do
      game_id = 0
      @datastore.store(game_id, {})

      get "/available_moves/#{@game_id}", nil, @request_headers
      expected_response = { 'available_moves':[1, 2, 3, 4, 5, 6, 7, 8, 9] }.to_json
      
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it "should return array of 3 to 9 for a game with 2 plays" do
      data = {'state': ["X", "O", "", "", "", "", "", "", ""]}
      @datastore.store(@game_id, data)

      get "/available_moves/#{@game_id}", nil, @request_headers
      @datastore.load(@game_id, :state)

      expected_response = { 'available_moves':[3, 4, 5, 6, 7, 8, 9] }.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it "should return an error if the game hasn't yet been created" do
      expected_response = { "error" => {"game": "game #{@game_id} hasn't yet started"} }.to_json
      get "/available_moves/#{@game_id}", nil, @request_headers
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end
  end


  context "Start Game" do
    before(:each) do
      @body = { 'game_id': @game_id }.to_json
      post '/startgame', @body, @request_headers
    end

    it "responds with the game Id" do
      expected_response = {"game_id":@game_id}.to_json
      expect(last_response).to be_ok
      expect(last_response.body['game_id']).to eq(expected_response['game_id'])
    end

    it "adds the game to the datastore" do
      expect(last_response).to be_ok
      expect(@datastore.load(@game_id, :state)).to be
    end

    it "adds a new state and turn X to the datastore" do
      expected_response = {
        'state': ['','','','','','','','',''],
        'turn': 'X'
      }
      expect(last_response).to be_ok
      expect(@datastore.load(@game_id, :state)).to eq(expected_response[:state])
      expect(@datastore.load(@game_id, :turn)).to eq(expected_response[:turn])
    end

    it "should return an error if you start a game which is already started" do
      post '/startgame', @body, @request_headers
      expected_response =  { "error": {"game": "game #{@game_id} already exists"} }.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end
  end


  context "Play" do
    it "should return error message for game that hasn't yet started" do
      body = {
        "game_id":@game_id,
        "player":1,
        "position":1
      }.to_json
      expected_response = {"error": {"game": "game hasn't yet started"}}.to_json
      post '/play', body, @request_headers

      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it "should validate game_id present" do
      body = {
        "player":1,
        "position":1
      }.to_json
      post '/play', body, @request_headers

      expect(last_response).to be_ok

      response = JSON.parse(last_response.body)
      expect(response).to include('error')
      expect(response['error']).to include('game_id')
      expect(response['error']['game_id']).to eq("game id must be present")
    end

    it "should validate player present" do
      body = {
        "game_id": 0,
        "position":1
      }.to_json
      post '/play', body, @request_headers

      expect(last_response).to be_ok
      
      response = JSON.parse(last_response.body)
      expect(response).to include('error')
      expect(response['error']).to include('player')
      expect(response['error']['player']).to eq("player must be present")
    end

    it "should validate position present" do
      body = {
        "game_id": 0,
        "player":1
      }.to_json
      post '/play', body, @request_headers

      expect(last_response).to be_ok

      response = JSON.parse(last_response.body)
      expect(response).to include('error')
      expect(response['error']).to include('position')
      expect(response['error']['position']).to eq("position must be present")
    end

    it "should validate the position, cannot play on already played position" do
      body1 = {
        "game_id":@game_id,
        "player":1,
        "position":3
      }.to_json

      body2 = {
        "game_id":@game_id,
        "player":2,
        "position":3
      }.to_json
      expected_response = {"error": {"position": "already occupied"}}.to_json
      @datastore.store(@game_id, {})

      post '/play', body1, @request_headers
      expect(last_response).to be_ok

      puts last_response.errors

      post '/play', body2, @request_headers

      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it "should store the move" do
      body = {
        "game_id":@game_id,
        "player":1,
        "position":1
      }.to_json
      state_before = {'state': ["", "", "", "", "", "", "", "", ""]}
      expected_state = ["X", "", "", "", "", "", "", "", ""]
      @datastore.store(@game_id, state_before)
      post '/play', body, @request_headers

      expect(last_response).to be_ok
      expect(@datastore.load(@game_id, :state)).to eq(expected_state)
    end

    it "should store multiple moves" do
      body1 = {
        "game_id":@game_id,
        "player":1,
        "position":3
      }.to_json

      body2 = {
        "game_id":@game_id,
        "player":2,
        "position":5
      }.to_json
      data = { "state": ["X", "", "", "", "", "", "", "", ""]}
      @datastore.store(@game_id, data)

      expected_state = ["X", "", "X", "", "O", "", "", "", ""]

      post '/play', body1, @request_headers
      post '/play', body2, @request_headers

      expect(last_response).to be_ok
      expect(@datastore.load(@game_id, :state)).to eq(expected_state)
    end

    it "should play O for player 2" do
      body = {
        "game_id":@game_id,
        "player":2,
        "position":3
      }.to_json
      data = { "state": ["X", "", "", "", "", "", "", "", ""], 'turn': 'O' }

      @datastore.store(@game_id, data)
      expected_state = ["X", "", "O", "", "", "", "", "", ""]

      post '/play', body, @request_headers

      expect(last_response).to be_ok
      expect(@datastore.load(@game_id, :state)).to eq(expected_state)
    end

    it "should return a win for player 1" do
      body = {
        "game_id":@game_id,
        "player":1,
        "position":3
      }.to_json

      data = { "state": ["X", "X", "", "", "", "", "", "", ""], 'turn': "X" }
      @datastore.store(@game_id, data)
      expected_response = {'win': "Player 1 is Winner"}.to_json

      post '/play', body, @request_headers

      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it "should return a win for player 2" do
      body = {
        "game_id":@game_id,
        "player":2,
        "position":3
      }.to_json

      data = { "state": ["O", "O", "", "", "", "", "", "", ""], 'turn': 'O' }
      @datastore.store(@game_id, data)
      expected_response = {'win': "Player 2 is Winner"}.to_json

      post '/play', body, @request_headers

      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it "should be able to handle 2 different games" do
      game_id1 = 1
      game_id2 = 2

      body1 = { "game_id": game_id1, "player":1, "position":1 }.to_json
      body2 = { "game_id": game_id2, "player":2, "position":2 }.to_json

      data = { "state": ["", "", "", "", "", "", "", "", ""], 'turn': 'X' }
      @datastore.store(game_id1, data)

      data = { "state": ["", "", "", "", "", "", "", "", ""], 'turn': 'O' }
      @datastore.store(game_id2, data)

      response1 = post '/play', body1, @request_headers
      response2 = post '/play', body2, @request_headers

      state1 = @datastore.load(game_id1, :state)
      state2 = @datastore.load(game_id2, :state)

      expected_state1 = ["X", "", "", "", "", "", "", "", ""]
      expected_state2 = ["", "O", "", "", "", "", "", "", ""]

      expect(response1).to be_ok
      expect(state1).to eq(expected_state1)

      expect(response2).to be_ok
      expect(state2).to eq(expected_state2)
    end

    it "should return the state in json" do
      body = { "game_id": @game_id, "player":1, "position":1 }.to_json
      @datastore.store(@game_id, {})
      post '/play', body, @request_headers
      expected_response = {game: ["X", "", "", "", "", "", "", "", ""]}.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end
  end

  context "Turns" do
    it "should ensure default turn is player 1" do
      body = { 'game_id': @game_id }.to_json
      post '/startgame', body, @request_headers

      turn_before = @datastore.load(@game_id, :turn)

      expect(last_response).to be_ok
      expect(turn_before).to eq("X")        
    end

    it "shoud switch turns after a move" do
      body = {
        "game_id":@game_id,
        "player":2,
        "position":3
      }.to_json

      data = {'turn': "O"}
      @datastore.store(@game_id, data)
      turn_before = @datastore.load(@game_id, :turn)

      post '/play', body, @request_headers
      turn_after = @datastore.load(@game_id, :turn)

      expect(last_response).to be_ok
      expect(turn_before).to eq("O")      
      expect(turn_after).to eq("X")      
    end

    it "shoud validates turn, only play on your turn" do
      body = {
        "game_id":@game_id,
        "player":1,
        "position":3
      }.to_json

      data = {'turn': "X"}
      @datastore.store(@game_id, data)
      turn_before = @datastore.load(@game_id, :turn)
      expect(turn_before).to eq("X")      

      post '/play', body, @request_headers
      turn_after = @datastore.load(@game_id, :turn)
      
      expect(last_response).to be_ok
      expect(turn_after).to eq("O") 

      post '/play', body, @request_headers
      expect(last_response).to be_ok

      response = JSON.parse(last_response.body)
      expect(response).to include('error')
      expect(response['error']).to include('turn')
      expect(response['error']['turn']).to eq("wrong turn")
    end

    it "should return X for a new game" do
      data = {'turn': 'X'}
      @datastore.store(@game_id, data)
      get "/turn/#{@game_id}", nil, @request_headers
      expected_response = {"turn": "X"}.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it "should return O for O's turn" do
      data = {'turn': 'O'}
      @datastore.store(@game_id, data)
      get "/turn/#{@game_id}", nil, @request_headers

      expected_response = {"turn": "O"}.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it "should validate turn, only started games" do
      get "/turn/#{@game_id}", nil, @request_headers
      expected_response = {"error": {"turn": "game #{@game_id} not started"}}.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end
  end

  context "games" do
    it "should return an empty hash when no game created" do
      get '/games', nil, @request_headers
      expected_response = {"games": {}}.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it "should return a hash of 1 game created" do
      default_data = {'state': ['', '', '', '', '', '', '', '', ''] ,'turn': "X"}
      @datastore.store(@game_id, default_data)
      get '/games', nil, @request_headers
      expected_response = {"games": {@game_id => default_data}}.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it "should return a hash of multiple games created" do
      default_data = {'state': ['', '', '', '', '', '', '', '', ''] ,'turn': "X"}
      @datastore.store(@game_id, default_data)
      @datastore.store(@game_id+1, default_data)
      get '/games', nil, @request_headers
      expected_response = {
        "games": {
          @game_id=> default_data,
          @game_id+1=> default_data
        }
      }.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end
  end
end