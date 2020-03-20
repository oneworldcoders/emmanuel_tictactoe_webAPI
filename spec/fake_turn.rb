class FakeTurn
    def initialize
        @turn = "X"
    end

    def get_turn
        @turn
    end
    
    def set_turn(turn)
        @turn = turn
    end

    def switch_turn
        @turn = @turn == "X" ? "O" : "X"
    end
    
end
