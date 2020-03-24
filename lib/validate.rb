class Validate

    attr_accessor :message
    def initialize
        @message = {"error": {}}
    end

    def return_status
        @message[:error].size > 0 ? false : true
    end

    def validate_startgame(game_id, datastore)
        @message[:error].store("game", "game #{game_id} already exists") if datastore.has_key?(game_id)
        return_status
    end

    def game_started?(game_id, datastore)
        @message[:error].store("game", "game #{game_id} hasn't yet started") if !datastore.has_key?(game_id)
        return_status
    end

    def validate_turns(game_id, datastore)
        @message[:error].store("turn", "game #{game_id} not started") if !datastore.has_key?(game_id)
        return_status
    end

    def validate_play(payload, datastore)
        @message[:error].store("game_id", "game id must be present") if !payload['game_id']
        @message[:error].store("player", "player must be present") if !payload['player']
        @message[:error].store("position", "position must be present") if !payload['position']
        @message[:error].store('game', "game hasn't yet started") if !datastore.has_key?(payload['game_id'])
        @message[:error].store('turn', "wrong turn") if !validate_turn(payload, datastore)
        @message[:error].store('position', "already occupied") if !validate_position(payload, datastore)
        return_status
    end

    def validate_turn(payload, datastore)
        turn_hash = {1=> "X", 2=> "O"}
        expected_turn = datastore.load(payload['game_id'], :turn)
        current_player = payload['player']

        turn_hash[current_player] == expected_turn
    end

    def validate_position(payload, datastore)
        current_position = payload['position'] || 0
        game_state = datastore.load(payload['game_id'], :state)
        game_state[current_position-1].empty?
    end

    def has_game_id?(datastore)
        datastore.has_key?(game_id)
    end
end
