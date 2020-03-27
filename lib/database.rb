require 'pg'

class Database

    def initialize(dbname="tictactoe_test", port="5432")
        @dbname = dbname
        @port = port
        @conn
    end

    def connect
        begin
            @conn = PG::Connection.new(:dbname => @dbname, :port => @port)
        rescue PG::Error => e
            puts e.message
            return false
        end
        true
    end

    def create_table(table_name, column_names, column_types)
        query = "CREATE TABLE IF NOT EXISTS #{table_name} ("
        column_names.zip(column_types) do |column_name, column_type|
            query += "#{column_name} #{column_type},"
        end
        @conn.exec(query.delete_suffix(',')+");")
    end
        
end
