class RandomTeam
  include ActiveModel::Model
  include ActiveModel::Attributes

  MAX_GENERATION_ATTEMPTS = 1_000

  attribute :list, :string
  attribute :players_per_team, :integer, default: 7
  attribute :teams, default: []

  validates :list, presence: true
  validates :players_per_team, presence: true

  def missing_players
    player_names = players.map { |player| player.name.downcase }
    player_names_from_list.reject { |name| player_names.include?(name) }
  end

  def generate!
    MAX_GENERATION_ATTEMPTS.times do |i|
      possible_teams = players.shuffle.each_slice(players_per_team).to_a
      possible_teams_weights = possible_teams.map { |team| team_weight(team) }
      diff_team_weight = possible_teams_weights.max - possible_teams_weights.min

      if diff_team_weight <= 2
        self.teams = possible_teams
        return
      end
    end
  end

  def players
    @players ||= Player.where('LOWER(name) IN (?)', player_names_from_list)
  end

  private

  def player_names_from_list
    list.split("\n")
      .map(&:strip)
      .reject(&:empty?)
      .map { |line| line.gsub(/^\d+\.\s*/, '') }
      .map(&:downcase)
  end

  def team_weight(team)
    team.reduce(0) { |sum, player| sum + player.level }
  end
end
