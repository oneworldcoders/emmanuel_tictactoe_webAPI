require "tic_tac_toe"

require_relative 'datastore'
require_relative 'player'
require_relative 'output'
require_relative 'validate'

require 'sinatra'
require "json"


class App < Sinatra::Base

    def initialize(app=nil, datastore={}, turn=TicTacToe::Turn.new, output = Output.new, game=TicTacToe::Game.new, validate=Validate.new)
        super(app)
        @datastore = datastore
        @turn = turn
        @game = game
        @output = output
        @validate = validate
    end

    before do
        content_type :json
    end

    get '/games' do
        {"games":@datastore.load_all()}.to_json
    end

    get '/' do
        {'message':@output.welcome}.to_json
    end

    get '/available_moves/:game_id' do
        game_id = params['game_id'].to_i
        if @validate.validate_available_moves(game_id, @datastore)
            @game.state = @datastore.load(game_id, :state)
            return {'available moves':@game.available_moves}.to_json
        else
            return @validate.message.to_json
        end
    end

    post '/startgame' do
        payload = JSON.parse(request.body.read)
        game_id = payload['game_id']

        return @validate.message.to_json unless @validate.validate_startgame(game_id, @datastore)
        
        data = {'state': @game.state, 'turn': @turn.get_turn}
        @datastore.store(game_id, data)
        return {
            "messgae":"game started successfully",
            "game_id":game_id,
            "game_data": data
        }.to_json
    end

    get '/turn/:game_id' do
        game_id = params['game_id'].to_i
        return @validate.message.to_json if !@validate.validate_turns(game_id, @datastore)
        {"turn": @datastore.load(game_id, :turn)}.to_json
    end

    post '/play' do
        payload = JSON.parse(request.body.read)

        return @validate.message.to_json if !@validate.validate_play(payload, @datastore)

        player = Player.create_player(payload['player'])
        position = payload['position']
        game_id = payload['game_id']
        
        @game.state = @datastore.load(game_id, :state)
        @turn.set_turn(@datastore.load(game_id, :turn))

        player.play(position, @game)
        @turn.switch_turn
        data = {'state': @game.state, 'turn': @turn.get_turn}
        @datastore.store(game_id, data)

        if @game.check_win(player.get_mark)
            return {'win':"player #{payload['player']}"}.to_json
        end

        @game.board_as_string
    end

end
