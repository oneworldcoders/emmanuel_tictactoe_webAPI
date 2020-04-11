class FakeGame
  attr_accessor :state

  def initialize()
    @state = nil
  end

  def state()
    true
  end

  def check_win(player = nil)
    return true
  end
end
