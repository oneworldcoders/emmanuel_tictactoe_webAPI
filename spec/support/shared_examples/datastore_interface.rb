shared_examples 'datastore interface' do
  it { is_expected.to respond_to(:clear).with(0).argument }
  it { is_expected.to respond_to(:key?).with(1).argument }
  it { is_expected.to respond_to(:store).with(2).argument }
  it { is_expected.to respond_to(:load_game).with(1).argument }
  it { is_expected.to respond_to(:load).with(2).argument }
  it { is_expected.to respond_to(:load_all).with(0).argument }
end
