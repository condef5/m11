class RandomTeam
  def initialize(players:, gap: 1, max_generation_attemps: 100, players_per_team:)
    @players = players
    @gap = gap.to_i
    @max_generation_attemps = max_generation_attemps.to_i
    @players_per_team = players_per_team.to_i
  end

  def generate
    @max_generation_attemps.times do |i|
      possible_teams = @players.shuffle.each_slice(@players_per_team).to_a
      possible_teams_weights = possible_teams.map { |team| team_weight(team) }
      diff_team_weight = possible_teams_weights.max - possible_teams_weights.min

      if diff_team_weight <= @gap && valid_teams?(possible_teams, @players)
        puts "Generation attempts: #{i}"
        puts "Teams: #{possible_teams}"
        return possible_teams
      end
    end

    []
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

  def team_weight(team)
    team.reduce(0) { |sum, player| sum + player.level }
  end
end
