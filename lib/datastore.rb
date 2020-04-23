require_relative '../serializers/game_serializer'

class Datastore
  def initialize(data = {}, serializer = GameSerializer.new)
    @data = data
    @game_serializer = serializer
  end

  def clear
    @data.clear
  end

  def key?(key)
    @data.key?(key)
  end

  def store(key, value)
    if value
      @data.store(key, value)
    else
      @data.store(key, @game_serializer.serialize())
    end
  end

  def load_game(game_id)
    @data.dig(game_id) || @game_serializer.serialize()
  end

  def load(game_id, key)
    @data.dig(game_id, key) || @game_serializer.serialize()[key]
  end

  def load_all
    @data
  end
end
