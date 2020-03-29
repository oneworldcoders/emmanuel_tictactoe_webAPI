require 'tic_tac_toe'

class DefaultGame

    def load_game(game_id)
        game = TicTacToe::Game.new
        turn = TicTacToe::Turn.new
        game.state
        {:state=> game.state, :turn=>turn.get_turn}
    end
end
