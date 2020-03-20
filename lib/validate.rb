class Validate

    attr_accessor :message
    def initialize
        @message = {"error": {}}
    end

    def validate_startgame(game_id, datastore)
        if datastore.has_key?(game_id)
            @message[:error].store("game", "game #{game_id} already exists")
            return false
        end
        return true
    end

    def validate_available_moves(game_id, datastore)
        if !datastore.has_key?(game_id)
            @message[:error].store("game", "game #{game_id} hasn't yet started")
            return false
        else
            return true
        end
    end

    def validate_turns(game_id, datastore)
        if !datastore.has_key?(game_id)
            @message[:error].store("turn", "game #{game_id} not started")
            return false
        else
            return true
        end
    end

    def validate_play(payload, datastore)
        if !payload['game_id']
            @message[:error].store("game_id", "game id must be present")
        elsif !payload['player']
            @message[:error].store("player", "player must be present")
        elsif !payload['position']
            @message[:error].store("position", "position must be present")
        elsif !datastore.has_key?(payload['game_id'])
            @message[:error].store('game', "game hasn't yet started")
        elsif !validate_turn(payload, datastore)
            @message[:error].store('turn', "wrong turn")
        elsif !validate_position(payload, datastore)
            @message[:error].store('position', "already occupied")
        else
            return true
        end
        return false
    end

    def validate_turn(payload, datastore)
        turn_hash = {1=> "X", 2=> "O"}
        expected_turn = datastore.load(payload['game_id'], :turn)
        current_player = payload['player']

        turn_hash[current_player] == expected_turn
    end

    def validate_position(payload, datastore)
        current_position = payload['position']
        game_state = datastore.load(payload['game_id'], :state)
        game_state[current_position-1].empty?
    end

    def has_game_id?(datastore)
        datastore.has_key?(game_id)
    end
end
