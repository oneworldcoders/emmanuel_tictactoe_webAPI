require 'tic_tac_toe'

class DefaultGame
  def initialize
    @game = TicTacToe::Game.new
    @turn = TicTacToe::Turn.new
  end

  def state
    @game.state
  end

  def turn
    @turn.get_turn
  end

  def load_game(_game_id)
    game = TicTacToe::Game.new
    turn = TicTacToe::Turn.new
    { state: game.state, turn: turn.get_turn }
  end
end
