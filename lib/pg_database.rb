require 'pg'
require_relative '../models/game'
require_relative '../serializers/game_serializer'

class PGDatabase
  def initialize(data = Game, serializer = GameSerializer.new)
    @data = data
    @serializer = serializer
  end

  def store(id, game_data)
    @data.find_or_initialize_by(game_id: id).update!(game_data || {})
  end

  def load_game(game_id)
    game = @data.find_by(game_id: game_id)
    @serializer.serialize(game)
  end

  def key?(game_id)
    @data.exists?(game_id: game_id)
  end

  def clear; end

  def load(game_id, key)
    game = @data.find_by(game_id: game_id)
    @serializer.serialize(game).dig(key)
  end

  def load_all
    game_hash = {}
    @data.find_each do |game|
      game_data = @serializer.serialize(game)
      game_hash.store(game.game_id, game_data)
    end
    game_hash
  end
end
