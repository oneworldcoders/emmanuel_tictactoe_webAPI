class FakeOutput

    attr_reader :welcome_text
    def initialize
        @welcome_text = false
    end

    def welcome
        @welcome_text = true
    end
end
