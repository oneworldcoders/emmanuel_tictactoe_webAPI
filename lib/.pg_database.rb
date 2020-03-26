require 'pg'

class PGDatabase

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
            query += "#{column_name} #{column_type}, "
        end
        query += "PRIMARY KEY (#{column_names.first}) );"
        @conn.exec(query)
    end

    def clear
       # Drop table game
        
    end

    def has_key?(key)
        # Select * from game where id == key
        # count = 1
    end

    def store(key, value)
        # insert into game game_id=key state=value.state turn=value.turn
        state = value['state']
        turn = value['turn']
        p '------'
        p state
        return updatte_state(key, state) if (value.size == 1 && state)
        return update_turn(key, turn) if (value.size == 1 && turn)
        query = "INSERT INTO Game (Game_Id, State, Turn)
                VALUES (#{key}, ARRAY ['#{state.join(',')}'], #{turn})
                ON DUPLICATE KEY UPDATE State=ARRAY ['#{state.join(',')}'], Turn=#{turn}};"
        @conn.exec(query)
    end

    def update_state(key, state)
        query = "INSERT INTO Game (Game_Id, State)
                VALUES (#{key}, ARRAY #{state})
                ON DUPLICATE KEY UPDATE State=#{state}};"
        @conn.exec(query)
    end

    def update_turn(key, turn)
        query = "INSERT INTO Game (Game_Id, Turn)
                VALUES (#{key}, #{turn})
                ON DUPLICATE KEY UPDATE Turn=#{turn}};"
        @conn.exec(query)
    end

    def load_game(game_id)
        # select * from game where id = gameid
    end

    def load(game_id, key)
        # Select key from game where d = game_id
    end

    def load_all
        # Select * from game
    end
end
