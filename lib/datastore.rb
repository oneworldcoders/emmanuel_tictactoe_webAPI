class Datastore

    def initialize(data={})
        @data = data
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
        @data[game_id][key]
    end

    def load_all
        @data
    end

end
