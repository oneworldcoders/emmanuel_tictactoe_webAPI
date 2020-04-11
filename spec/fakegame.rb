class FakeGame
  attr_accessor :state

  def initialize
    @state = nil
  end

  def check_win(_player = nil)
    true
  end
end
