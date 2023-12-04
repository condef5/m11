class CreateGameDays < ActiveRecord::Migration[7.1]
  def change
    create_table :game_days do |t|
      t.text :player_list
      t.integer :players_per_team, default: 7
      t.integer :generation_attempts, default: 0

      t.timestamps
    end
  end
end
