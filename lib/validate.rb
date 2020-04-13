class Validate
  attr_accessor :message
  def initialize
    @message = { "error": {} }
  end

  def determine_return_status
    @message[:error].size <= 0
  end

  def validate_game_started(game_id, web_game)
    game_started?(game_id, web_game)
    determine_return_status
  end

  def game_started?(game_id, web_game)
    return if web_game.game?(game_id)

    @message[:error].store('game', "game #{game_id} hasn't yet started")
  end

  def validate_turns(game_id, web_game)
    unless web_game.game?(game_id)
      @message[:error].store('turn', "game #{game_id} not started")
    end
    determine_return_status
  end

  def validate_play(payload, web_game)
    data?(payload)
    game_started?(payload['game_id'], web_game)
    unless validate_turn(payload, web_game)
      @message[:error].store('turn', 'wrong turn')
    end
    unless validate_position(payload, web_game)
      @message[:error].store('position', 'already occupied')
    end
    determine_return_status
  end

  def data?(payload)
    validations = %w[game_id player position]
    validations.each do |validation|
      unless payload[validation]
        @message[:error].store(validation, "#{validation} must be present")
      end
    end
  end

  def validate_turn(payload, web_game)
    turn_hash = { 1 => 'X', 2 => 'O' }
    expected_turn = web_game.load_turn(payload['game_id'])
    current_player = payload['player']

    turn_hash[current_player] == expected_turn
  end

  def validate_position(payload, web_game)
    current_position = payload['position'] || 0
    game_state = web_game.load_state(payload['game_id'])
    game_state[current_position - 1].empty?
  end
end
