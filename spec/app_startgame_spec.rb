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

  context 'Start Game' do
    before(:each) do
      @body = { 'game_id': @game_id }.to_json
      post '/startgame', @body, @request_headers
    end

    it 'responds with the game data' do
      expected_response = {
        'game_data' => {
          @game_id.to_s => {
            'state' => ['', '', '', '', '', '', '', '', ''],
            'turn' => 'X'
          }
        }
      }
      expect(last_response).to be_ok
      response = JSON.parse(last_response.body)
      expect(response['game_data']).to eq(expected_response['game_data'])
    end

    it 'adds the game to the web game' do
      expect(last_response).to be_ok
      expect(@web_game.load_state(@game_id)).not_to be_nil
    end

    it 'adds a new state and turn X to the game' do
      expected_response = {
        'state': ['', '', '', '', '', '', '', '', ''],
        'turn': 'X'
      }
      expect(last_response).to be_ok
      expect(@web_game.load_state(@game_id)).to eq(expected_response[:state])
      expect(@web_game.load_turn(@game_id)).to eq(expected_response[:turn])
    end

    it 'should return an error if you start a game which is already started' do
      post '/startgame', @body, @request_headers
      expected_response = { "error": {
        "game": "game #{@game_id} already exists"
      } }.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end
  end
end
