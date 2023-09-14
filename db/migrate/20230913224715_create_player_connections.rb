class CreatePlayerConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :player_connections do |t|
      t.integer :relation_type
      t.references :author, null: false, foreign_key: { to_table: :players }
      t.references :connected_player, null: false, foreign_key: { to_table: :players }

      t.timestamps
    end

    add_index :player_connections, [:author_id, :connected_player_id], unique: true, name: 'unique_player_connection_index'
  end
end
