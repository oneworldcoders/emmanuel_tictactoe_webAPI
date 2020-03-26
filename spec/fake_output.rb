class FakeOutput

    attr_reader :welcome_text, :winner_text
    def initialize
        @welcome_text = false
        @winner_text = false
    end

    def welcome
        @welcome_text = true
    end

    def get_winner_text(player)
        @winner_text = true
    end
end
