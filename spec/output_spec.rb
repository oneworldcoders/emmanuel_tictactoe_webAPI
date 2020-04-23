require_relative 'fake_output'

describe 'Output' do
  it 'should call welcome' do
    output = FakeOutput.new
    expect(output.welcome_text).to be false
    output.welcome
    expect(output.welcome_text).to be true
  end

  it 'should call get the winner text' do
    output = FakeOutput.new
    output.get_winner_text(1)
    expect(output.winner_text).to be true
  end

  it 'should get the winner text for player 1' do
    output = Output.new
    player = 1
    expect(output.get_winner_text(player)).to eq('Player 1 is Winner')
  end

  it 'should call get the winner text for player 2' do
    output = Output.new
    player = 2
    expect(output.get_winner_text(player)).to eq('Player 2 is Winner')
  end
end

describe 'Output' do
  context 'Language' do
    it 'should get the current language' do
      output = Output.new
      expect(output.language).to eq('en')
    end

    it 'should return fr' do
      output = Output.new(TicTacToe::Output.new(TicTacToe::Language.new('fr')))
      expect(output.language).to eq('fr')
    end

    it 'should set the language to en' do
      output = Output.new
      output.update_language('en')
      expect(output.language).to eq('en')
    end

    it 'should set the language to fr' do
      output = Output.new
      output.update_language('fr')
      expect(output.language).to eq('fr')
    end

    it 'should set the language to fr' do
      output = Output.new
      output.update_language('fra')
      expect(output.language).to eq('en')
    end
  end
end

describe 'Lang' do
  context 'Language' do
    it 'should return 1 for en' do
      expect(Lang.get_language_value('en')).to eq(1)
    end

    it 'should return 2 for fr' do
      expect(Lang.get_language_value('fr')).to eq(2)
    end

    it 'should return 3 for krw' do
      expect(Lang.get_language_value('krw')).to eq(3)
    end

    it 'should return 1 for unknown language' do
      expect(Lang.get_language_value('luganda')).to eq(1)
    end
  end
end
