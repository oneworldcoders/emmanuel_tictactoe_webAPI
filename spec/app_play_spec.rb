require 'app'
require 'web_game'

require 'rack/test'
require 'rspec'

describe 'The App' do
  include Rack::Test::Methods

  def app
    App.new(nil, @web_game)
  end

  before(:each) do
    @game_id = 0
    @web_game = WebGame.new
    @request_headers = { 'CONTENT_TYPE' => 'application/json' }
  end

  after(:each) do
    @web_game.clear_all
  end

  context 'Play' do
    before(:each) do
      @body1 = { "game_id": @game_id, "player": 1, "position": 1 }.to_json
      @body2 = { "game_id": @game_id, "player": 2, "position": 3 }.to_json
      @body_no_id = { "player": 1, "position": 1 }.to_json
      @body_no_player = { "game_id": 0, "position": 1 }.to_json
      @body_no_position = { "game_id": 0, "player": 1 }.to_json
    end

    it "should return error message for game that hasn't yet started" do
      expected_response = {
        "error": {
          "game": "game #{@game_id} hasn't yet started"
        }
      }.to_json
      post '/play', @body1, @request_headers
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it 'should validate game_id present' do
      post '/play', @body_no_id, @request_headers
      expect(last_response).to be_ok
      response = JSON.parse(last_response.body)
      expect(response).to include('error')
      expect(response['error']).to include('game_id')
      expect(response['error']['game_id']).to eq('game_id must be present')
    end

    it 'should validate player present' do
      post '/play', @body_no_player, @request_headers
      expect(last_response).to be_ok
      response = JSON.parse(last_response.body)
      expect(response).to include('error')
      expect(response['error']).to include('player')
      expect(response['error']['player']).to eq('player must be present')
    end

    it 'should validate position present' do
      post '/play', @body_no_position, @request_headers
      expect(last_response).to be_ok
      response = JSON.parse(last_response.body)
      expect(response).to include('error')
      expect(response['error']).to include('position')
      expect(response['error']['position']).to eq('position must be present')
    end

    it 'should validate the position, cannot play on already played position' do
      data = { @game_id => { 'state': ['X', '', '', '', '', '', '', '', ''] } }
      expected = { "error": { "position": 'already occupied' } }.to_json
      @web_game.store(data)
      post '/play', @body1, @request_headers
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected)
    end

    it 'should store the move' do
      state_before = { 'state': ['', '', '', '', '', '', '', '', ''] }
      expected_state = ['X', '', '', '', '', '', '', '', '']
      @web_game.store({ @game_id => state_before })
      post '/play', @body1, @request_headers
      expect(last_response).to be_ok
      expect(@web_game.load_state(@game_id)).to eq(expected_state)
    end

    it 'should store multiple moves' do
      @web_game.store({ @game_id => {} })
      expected_state = ['X', '', 'O', '', '', '', '', '', '']
      post '/play', @body1, @request_headers
      post '/play', @body2, @request_headers
      expect(last_response).to be_ok
      expect(@web_game.load_state(@game_id)).to eq(expected_state)
    end

    it 'should play O for player 2' do
      @web_game.store({ @game_id => { 'turn': 'O' } })
      expected_state = ['', '', 'O', '', '', '', '', '', '']
      post '/play', @body2, @request_headers
      expect(last_response).to be_ok
      expect(@web_game.load_state(@game_id)).to eq(expected_state)
    end

    it 'should return a win for player 1' do
      data = { "state": ['', 'X', 'X', '', '', '', '', '', ''], 'turn': 'X' }
      @web_game.store({ @game_id => data })
      expected_response = { 'win': 'Player 1 is Winner' }.to_json
      post '/play', @body1, @request_headers
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it 'should return a win for player 2' do
      data = { "state": ['O', 'O', '', '', '', '', '', '', ''], 'turn': 'O' }
      @web_game.store({ @game_id => data })
      expected_response = { 'win': 'Player 2 is Winner' }.to_json
      post '/play', @body2, @request_headers
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it 'should be able to handle 2 different games' do
      game_id1 = 1
      game_id2 = 2

      body1 = { "game_id": game_id1, "player": 1, "position": 1 }.to_json
      body2 = { "game_id": game_id2, "player": 2, "position": 2 }.to_json

      @web_game.store({ game_id1 => {} })
      @web_game.store({ game_id2 => { 'turn': 'O' } })

      response1 = post '/play', body1, @request_headers
      response2 = post '/play', body2, @request_headers

      state1 = @web_game.load_state(game_id1)
      state2 = @web_game.load_state(game_id2)

      expected_state1 = ['X', '', '', '', '', '', '', '', '']
      expected_state2 = ['', 'O', '', '', '', '', '', '', '']

      expect(response1).to be_ok
      expect(state1).to eq(expected_state1)

      expect(response2).to be_ok
      expect(state2).to eq(expected_state2)
    end

    it 'should return the state in json' do
      @web_game.store({ @game_id => {} })
      post '/play', @body1, @request_headers
      response = { game: ['X', '', '', '', '', '', '', '', ''] }.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(response)
    end
  end
end
