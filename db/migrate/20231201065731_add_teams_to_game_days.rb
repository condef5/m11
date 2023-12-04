class AddTeamsToGameDays < ActiveRecord::Migration[7.1]
  def change
    add_column :game_days, :teams, :jsonb, default: [], null: false
  end
end
