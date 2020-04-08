require "tic_tac_toe"
require "sinatra"
require "json"

require_relative "player"
require_relative "output"
require_relative "validate"
require_relative "web_game"

class App < Sinatra::Base
  def initialize(app = nil, web_game = WebGame.new, output = Output.new)
    super(app)
    @web_game = web_game
    @output = output
  end

  configure do
    enable :cross_origin
  end

  before do
    content_type :json
    @validate = Validate.new
    response.headers["Access-Control-Allow-Origin"] = "*"
  end

  after do
    response.body = JSON.dump(response.body)
  end

  get "/games" do
    return { games: @web_game.load_all }
  end

  get "/" do
    payload = request.body.read.empty? ? {} : JSON.parse(request.body.read)
    lang = payload["lang"]
    @output.update_language(lang)
    return { message: @output.welcome }
  end

  get "/available_moves/:game_id" do
    game_id = params["game_id"].to_i
    unless @validate.validate_game_started(game_id, @web_game)
      return @validate.message
    end

    @web_game.load_state(game_id)
    return { available_moves: @web_game.available_moves }
  end

  post "/startgame" do
    payload = JSON.parse(request.body.read)
    game_id = payload["game_id"]

    unless @validate.validate_startgame(game_id, @web_game)
      return @validate.message
    end

    @web_game.start_game(game_id)
    return {
             messgae: "game started successfully",
             game_data: { "#{game_id}": @web_game.get_game(game_id) },
           }
  end

  get "/turn/:game_id" do
    game_id = params["game_id"].to_i
    return @validate.message unless @validate.validate_turns(game_id, @web_game)

    return { turn: @web_game.load_turn(game_id) }
  end

  post "/play" do
    payload = JSON.parse(request.body.read)
    lang = payload["lang"]
    @output.update_language(lang)

    return @validate.message unless @validate.validate_play(payload, @web_game)

    player = Player.create_player(payload["player"])
    position = payload["position"]
    game_id = payload["game_id"]

    @web_game.load_state(game_id)
    @web_game.load_turn(game_id)
    @web_game.play(player, position)
    @web_game.switch_turn(game_id)
    @web_game.save_game(game_id)


    if @web_game.draw?(game_id)
      { game: @web_game.load_state(game_id),draw: @output.draw_text }
    elsif @web_game.check_win(game_id, player)
      { game: @web_game.load_state(game_id),win: @output.get_winner_text(payload["player"]) }
    else
      { game: @web_game.load_state(game_id) }
    end
  end
  options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end
end
