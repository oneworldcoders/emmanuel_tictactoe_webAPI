class FakePGDatabase
  def initialize; end

  def find_by(hash)
    DataModel.new(hash[:game_id])
  end

  def exists?(hash)
    hash[:game_id] == 1
  end

  def find_or_initialize_by(_hash)
    self
  end

  def update_attributes!(_hash)
    true
  end

  def find_each
    yield DataModel.new(1)
  end
end

class DataModel
  attr_reader :game_id
  def initialize(game_id)
    @game_id = game_id
  end

  def state
    return [''] if @game_id == 1
    return ['', '', '', '', '', '', '', '', ''] if @game_id == 0
  end

  def turn
    'X'
  end
end
