class Output
  def initialize(output = TicTacToe::Output.new)
    @output = output
  end

  def welcome
    @output.get_welcome_message
  end

  def update_language(lang)
    @output.set_language(Lang.get_language_value(lang))
  end

  def language
    @output.get_language
  end

  def get_winner_text(player)
    player == 1 ? @output.get_player1_win_text : @output.get_player2_win_text
  end

  def draw_text
    @output.get_draw_text
  end
end

class Lang
  LANG = {
    'en' => 1,
    'fr' => 2,
    'krw' => 3
  }.freeze

  def self.get_language_value(key)
    LANG[key] || 1
  end
end
