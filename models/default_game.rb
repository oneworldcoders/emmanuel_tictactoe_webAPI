require 'tic_tac_toe'

class DefaultGame
  def initialize
  end

  def state
    TicTacToe::Game.new.state
  end

  def turn
    TicTacToe::Turn.new.get_turn
  end
end
