class Game < ActiveRecord::Migration[6.0]
  def up
    create_table :games do |t|
      t.text :game_id, null: false
      t.text :state, array: true, default: "{'','','','','','','','',''}"
      t.text :turn, default: 'X'
    end
  end

  def down
    drop_table :games
  end
end
