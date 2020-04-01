require 'player'
require 'rspec'

RSpec.describe Player do
  it 'should create a player with an X for input 1' do
    player = Player.create_player(1)
    expect(player.get_mark).to eq('X')
  end

  it 'should create a player with an O for input 2' do
    player = Player.create_player(2)
    expect(player.get_mark).to eq('O')
  end
end
