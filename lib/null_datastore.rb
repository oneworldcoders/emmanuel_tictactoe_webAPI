class NullDatastore
    def load(game_id, key)
        key == :state ? ['', '', '' ,'', '', '', '', '', ''] : "X"
    end
end
