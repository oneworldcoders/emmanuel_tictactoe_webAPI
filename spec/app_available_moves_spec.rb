describe 'The App' do
  include Rack::Test::Methods

  def app
    App.new(nil, @web_game)
  end

  before(:each) do
    @game_id = '0'
    @web_game = WebGame.new
    @request_headers = { 'CONTENT_TYPE' => 'application/json' }
  end

  context 'Available moves' do
    it 'should return array of 1 to 9 for new game' do
      @web_game.store({ @game_id => {} })
      get "/available_moves/#{@game_id}", nil, @request_headers
      response = { 'available_moves': [1, 2, 3, 4, 5, 6, 7, 8, 9] }.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(response)
    end

    it 'should return array of 3 to 9 for a game with 2 plays' do
      data = { @game_id => { 'state': ['X', 'O', '', '', '', '', '', '', ''] } }
      @web_game.store(data)
      get "/available_moves/#{@game_id}", nil, @request_headers
      expected_response = { 'available_moves': [3, 4, 5, 6, 7, 8, 9] }.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it "should return an error if the game hasn't yet been created" do
      expected_response = { 'error' => {
        "game": "game #{@game_id} hasn't yet started"
      } }.to_json
      get "/available_moves/#{@game_id}", nil, @request_headers
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end
  end
end
