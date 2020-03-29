class Validate

    attr_accessor :message
    def initialize
        @message = {"error": {}}
    end

    def determine_return_status
        @message[:error].size > 0 ? false : true
    end

    def validate_startgame(game_id, web_game)
        @message[:error].store("game", "game #{game_id} already exists") if web_game.has_game?(game_id)
        determine_return_status
    end

    def game_started?(game_id, web_game)
        @message[:error].store("game", "game #{game_id} hasn't yet started") if !web_game.has_game?(game_id)
        determine_return_status
    end

    def validate_turns(game_id, web_game)
        @message[:error].store("turn", "game #{game_id} not started") if !web_game.has_game?(game_id)
        determine_return_status
    end

    def validate_play(payload, web_game)
        @message[:error].store("game_id", "game id must be present") if !payload['game_id']
        @message[:error].store("player", "player must be present") if !payload['player']
        @message[:error].store("position", "position must be present") if !payload['position']
        @message[:error].store('game', "game hasn't yet started") if !web_game.has_game?(payload['game_id'])
        @message[:error].store('turn', "wrong turn") if !validate_turn(payload, web_game)
        @message[:error].store('position', "already occupied") if !validate_position(payload, web_game)
        determine_return_status
    end

    def validate_turn(payload, web_game)
        turn_hash = {1=> "X", 2=> "O"}
        expected_turn = web_game.load_turn(payload['game_id'])
        current_player = payload['player']

        turn_hash[current_player] == expected_turn
    end

    def validate_position(payload, web_game)
        current_position = payload['position'] || 0
        game_state = web_game.load_state(payload['game_id'])
        game_state[current_position-1].empty?
    end

    def has_game_id?(web_game)
        web_game.has_game?(game_id)
    end
end
