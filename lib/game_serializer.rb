require_relative 'default_game'

class GameSerializer
  def initialize
    @default_game = DefaultGame.new
  end

  def serialize(model)
    state = model ? model.state : @default_game.state
    turn = model ? model.turn : @default_game.turn
    { state: state, turn: turn }
  end
end
