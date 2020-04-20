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

  describe 'Turns' do
    context 'validation' do
      it 'shoud validates turn, only play on your turn' do
        body = {
          "game_id": @game_id,
          "player": 1,
          "position": 3
        }.to_json

        data = { 'turn': 'X' }
        @web_game.store({ @game_id => data })
        turn_before = @web_game.load_turn(@game_id)
        expect(turn_before).to eq('X')

        post '/play', body, @request_headers
        turn_after = @web_game.load_turn(@game_id)

        expect(last_response).to be_ok
        expect(turn_after).to eq('O')

        post '/play', body, @request_headers
        expect(last_response).to be_ok

        response = JSON.parse(last_response.body)
        expect(response).to include('error')
        expect(response['error']).to include('turn')
        expect(response['error']['turn']).to eq('wrong turn')
      end

      it 'should validate turn, only started games' do
        get "/turn/#{@game_id}", nil, @request_headers
        expected_response = {
          "error": {
            "turn": "game #{@game_id} not started"
          }
        }.to_json
        expect(last_response).to be_ok
        expect(last_response.body).to eq(expected_response)
      end
    end
    it 'should ensure default turn is player 1' do
      body = { 'game_id': @game_id }.to_json
      post '/startgame', body, @request_headers

      turn_before = @web_game.load_turn(@game_id)

      expect(last_response).to be_ok
      expect(turn_before).to eq('X')
    end

    it 'shoud switch turns after a move' do
      body = {
        "game_id": @game_id,
        "player": 2,
        "position": 3
      }.to_json

      data = { 'turn': 'O' }
      @web_game.store({ @game_id => data })
      turn_before = @web_game.load_turn(@game_id)

      post '/play', body, @request_headers
      turn_after = @web_game.load_turn(@game_id)

      expect(last_response).to be_ok
      expect(turn_before).to eq('O')
      expect(turn_after).to eq('X')
    end

    it 'should return X for a new game' do
      data = { 'turn': 'X' }
      @web_game.store({ @game_id => data })
      get "/turn/#{@game_id}", nil, @request_headers
      expected_response = { "turn": 'X' }.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end

    it "should return O for O's turn" do
      data = { 'turn': 'O' }
      @web_game.store({ @game_id => data })
      get "/turn/#{@game_id}", nil, @request_headers

      expected_response = { "turn": 'O' }.to_json
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end
  end
end
