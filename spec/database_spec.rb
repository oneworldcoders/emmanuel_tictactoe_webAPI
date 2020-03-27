require 'rspec'
require 'database'

describe Database do
    context "Connect Database" do
        it "establishes a new conection" do
            dbname = "tictactoe_test"
            port = "5432"
            database  = Database.new(dbname, port)
            expect(database.connect).to be true
        end
    
        it "establishes a new conection using defaults" do
            database  = Database.new
            expect(database.connect).to be true
        end
    
        it "handle an exception when wrong dbname is used" do
            dbname = "wrong_test"
            database  = Database.new(dbname)
            expect(database.connect).to be false
        end
    end

    context "Create table" do
        before(:each) do
            @database  = Database.new
            @database.connect
    
            @table_name = "Game"
            @column_name = ["State"]
            @column_type = ["VARCHAR(255)"]
        end

        it "creates a table with 1 column in the database" do
            query = @database.create_table(@table_name, @column_name, @column_type)
            expect(query).to be_instance_of(PG::Result)
        end
        
        it "doesn't override game" do
            query1 = @database.create_table(@table_name, @column_name, @column_type)
            expect(query1).to be_instance_of(PG::Result)
    
            query2 = @database.create_table(@table_name, @column_name, @column_type)
            expect(query2).to be_instance_of(PG::Result)
        end

        it "creates a table with multiplle columns in the database" do
            column_names = ["Game_Id", "State", "Turn"]
            column_types = ["INT", "VARCHAR(255)", "CHAR(1)"]
            query = @database.create_table(@table_name, column_names, column_types)
            expect(query).to be_instance_of(PG::Result)
        end
    end

    context "Store to table" do
        it "adds a record to the table" do
            @database  = Database.new
            @database.connect
            @table_name = "Game"
            @column_name = ["State"]
            @column_type = ["VARCHAR(255)"]
            @database.create_table(@table_name, column_name, column_type)

            keys = []
            values= []
            
            @database.insert(@table_name, keys, values)
        end
    end
    
end