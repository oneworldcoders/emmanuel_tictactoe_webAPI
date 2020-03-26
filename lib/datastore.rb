require_relative 'null_datastore'

class Datastore

    def initialize(data={})
        @data = data
        @null_datastore = NullDatastore.new
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

    def load(game_id, key)
        @data.dig(game_id, key)|| @null_datastore.load(game_id, key)
    end

    def load_all
        @data
    end

end
