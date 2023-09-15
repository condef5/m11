class RandomTeam
  include ActiveModel::Model
  include ActiveModel::Attributes

  MAX_GENERATION_ATTEMPTS = 10

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

      if diff_team_weight <= 2 && valid_teams?(possible_teams, players)
        self.teams = possible_teams
        return
      end
    end
  end

  def valid_teams?(possible_teams, players)
    player_ids = players.pluck(:id)

    possible_teams.each do |team|
      team.each do |player|
        next if player.friends.empty?

        friend_ids = player.friends.pluck(:id)
        playing_friend_ids = friend_ids.select { |id| player_ids.include?(id) }
        team_player_ids = team.pluck(:id)
        all_friends_are_in_team = playing_friend_ids.all? { |id| team_player_ids.include?(id) }

        return false unless all_friends_are_in_team
      end
    end

    possible_teams.each do |team|
      team.each do |player|
        next if player.avoids.empty?

        avoids_ids = player.avoids.pluck(:id)
        team_player_ids = team.pluck(:id)
        avoids_are_in_team = avoids_ids.any? { |id| team_player_ids.include?(id) }

        return false if avoids_are_in_team
      end
    end

    true
  end


  def players
    @players ||= Player
      .includes(:friends, :avoids).select(:name, :level, :id)
      .where('LOWER(name) IN (?)', player_names_from_list).distinct
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
