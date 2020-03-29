class FakeDatastore
  def initialize(data = {})
    @data = data
  end

  def load(game_id, key)
    return key == :state ? [] : 'X' unless @data.dig(game_id, key)

    @data.dig(game_id, key)
  end

  def load_all
    @data
  end

  def store(key, value)
    @data.store(key, value)
  end

  def clear
    @data.clear
  end
end
