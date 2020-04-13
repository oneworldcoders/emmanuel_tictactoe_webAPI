require_relative 'datastore'
require 'tic_tac_toe'
require_relative 'player'

class WebGame
  def initialize(
    datastore = Datastore.new,
    game = TicTacToe::Game.new,
    turn = TicTacToe::Turn.new,
    uuid = UUID.new
  )
    @datastore = datastore
    @game = game
    @turn = turn
    @uuid = uuid
    @players = [[1, Player.create_player(1)], [2, Player.create_player(2)]]
  end

  def load_state(game_id)
    @game.state = @datastore.load(game_id, :state)
  end

  def load_turn(game_id)
    @turn.set_turn(@datastore.load(game_id, :turn))
  end

  def load_all
    @datastore.load_all
  end

  def clear_all
    @datastore.clear
  end

  def save_game(game_id)
    data = { game_id => { 'state': @game.state, 'turn': @turn.get_turn } }
    store(data)
  end

  def start_game(game_id = @uuid.generate)
    data = { game_id => nil }
    store(data)
    game_id
  end

  def get_game(game_id)
    @datastore.load_game(game_id)
  end

  def get_winner(game_id)
    load_state(game_id)
    @players.each do |player|
      return player[0] if player[1] && @game.check_win(player[1].get_mark)
    end
    nil
  end

  def game_end?(game_id)
    get_winner(game_id) || draw?(game_id)
  end

  def draw?(game_id)
    load_state(game_id)
    @game.draw?
  end

  def game?(game_id)
    @datastore.key?(game_id)
  end

  def store(data)
    id = data.keys.first
    game_data = data.dig(id)
    @datastore.store(id, game_data)
  end

  def play(player, position)
    player.play(position, @game)
  end

  def switch_turn(game_id)
    @turn.switch_turn
    data = { game_id => { 'turn' => @turn.get_turn } }
    store(data)
  end

  def available_moves
    @game.available_moves
  end
end
