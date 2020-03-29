require_relative 'default_game'

class Datastore

    def initialize(data={})
        @data = data
        @default_game = DefaultGame.new
    end

    def clear
        @data.clear
    end

    def has_key?(key)
        @data.has_key?(key)
    end

    def store(key, value)
        @data.store(key, value)
    end

    def load_game(game_id)
        @data.dig(game_id) || @default_game.load_game(game_id)
    end

    def load(game_id, key)
        @data.dig(game_id, key) || @default_game.load_game(game_id)[key]
    end

    def load_all
        @data
    end

end