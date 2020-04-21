describe 'Games Endpoint' do
  include Rack::Test::Methods

  def app
    App.new(nil, @web_game)
  end

  before(:each) do
    @game_id = 0
    @web_game = WebGame.new
    @request_headers = { 'CONTENT_TYPE' => 'application/json' }
  end

  context 'Get all games' do
    before(:each) do
      @default_data = {
        'state': ['', '', '', '', '', '', '', '', ''],
        'turn': 'X'
      }
      @web_game.store({ @game_id => @default_data })
    end

    it 'should return an empty hash when no game created' do
      @web_game.clear_all
      get '/games', nil, @request_headers
      expected_response = { "games": {} }.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it 'should return a hash of 1 game created' do
      get '/games', nil, @request_headers
      expected_response = { "games": { @game_id => @default_data } }.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it 'should return a hash of multiple games created' do
      @web_game.store({ @game_id + 1 => @default_data })
      get '/games', nil, @request_headers
      expected_response = {
        "games": {
          @game_id => @default_data,
          @game_id + 1 => @default_data
        }
      }.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end
  end
end
