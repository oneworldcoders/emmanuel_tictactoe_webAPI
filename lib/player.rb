class Player
  def self.create_player(player)
    player == 1 ? TicTacToe::Player.new('X') : TicTacToe::Player.new('O')
  end
end
