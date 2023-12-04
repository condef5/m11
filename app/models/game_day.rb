# == Schema Information
#
# Table name: game_days
#
#  id                  :bigint           not null, primary key
#  generation_attempts :integer          default(1000)
#  player_list         :text
#  players_per_team    :integer          default(7)
#  teams               :jsonb            not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class GameDay < ApplicationRecord
  def self.current
    last || new
  end

  def players
    @players ||= Player
      .includes(:friends, :avoids).select(:name, :level, :id)
      .where('LOWER(name) IN (?)', format_list).distinct
  end

  def save_teams_and_increase_attemps(teams)
    format_teams = teams.map { |team| team.map { |player| player.slice(:name, :level, :id) } }
    new_attemps = generation_attempts + 1
    update(teams: format_teams, generation_attempts: new_attemps)
  end

  def format_list
    player_list.split("\n")
    .map(&:strip)
    .reject(&:empty?)
    .map { |line| line.gsub(/^\d+\.\s*/, '') }
    .map(&:downcase)
  end
end
