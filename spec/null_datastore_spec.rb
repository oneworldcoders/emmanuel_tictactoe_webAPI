require 'null_datastore'
require 'rspec'

RSpec.describe NullDatastore do
    context "Load data" do
        before(:each) do
            @null_datastore = NullDatastore.new
            @game_id = 1
        end

        it "returns default empty state when not defined" do
            expected_result = ['', '', '', '', '', '', '', '', '']
            expect(@null_datastore.load(@game_id, :state)).to eq(expected_result)
        end

        it "returns default turn X when not defined" do
            expected_result = "X"
            expect(@null_datastore.load(@game_id, :turn)).to eq(expected_result)
        end
    end
end
