require 'pg'
require_relative '../models/game'
require_relative 'default_game'

class PGDatabase
  def initialize(data = Game)
    @data = data
    @default_game = DefaultGame.new
  end

  def store(id, game_data)
    state = game_data&.dig(:state) || @default_game.load_game(id)[:state]
    turn = game_data&.dig(:turn) || @default_game.load_game(id)[:turn]
    @data.find_or_initialize_by(game_id: id)
         .update_attributes!(state: state, turn: turn)
  end

  def load_game(game_id)
    game = @data.find_by(game_id: game_id)
    { 'state': game.state, 'turn': game.turn }
  end

  def key?(game_id)
    @data.exists?(game_id: game_id)
  end

  def clear
    raise 'Not implemeted'
  end

  def load(game_id, key)
    key?(game_id) ? @data.find_by(game_id: game_id).public_send(key) : @default_game.load_game(game_id)[key]
  end

  def load_all
    game_hash = {}
    @data.find_each do |game|
      game_data = { 'state' => game.state, 'turn' => game.turn }
      game_hash.store(game.game_id, game_data)
    end
    game_hash
  end
end
