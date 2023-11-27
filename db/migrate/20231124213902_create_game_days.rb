class CreateGameDays < ActiveRecord::Migration[7.1]
  def change
    create_table :game_days do |t|
      t.text :player_list

      t.timestamps
    end
  end
end
