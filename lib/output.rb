class Output
    def initialize(output=TicTacToe::Output.new)
        @output = output
    end

    def welcome
        @output.get_welcome_message
    end

end
