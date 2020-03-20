require 'fake_output'

RSpec.describe FakeOutput do
    it "should call welcome" do
        output = FakeOutput.new
        expect(output.welcome_text).to be false
        output.welcome
        expect(output.welcome_text).to be true
    end
end
