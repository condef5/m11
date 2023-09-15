# test/models/random_team_test.rb

require "test_helper"

class RandomTeamTest < ActiveSupport::TestCase
  def setup
    @frank_player = Player.create(name: "Frank", level: 4)
    @sandrito_player = Player.create(name: "Sandrito", level: 4)
    @davis_player = Player.create(name: "Davis", level: 4)
    @vladi_player = Player.create(name: "Vladi", level: 4)

    @list = """
      1. Frank
      2. Sandrito
      3. Davis
      4. Vladi
    """
  end

  test "generate teams successfully with existing players" do
    random_team = RandomTeam.new(list: @list, players_per_team: 2)

    assert_equal 0, random_team.missing_players.size

    random_team.generate!

    assert_equal 2, random_team.teams.size
    [@frank_player, @sandrito_player, @davis_player, @vladi_player].each do |player|
      assert_includes random_team.players, player
    end
  end


  test "identify missing players before generating teams" do
    @list = """
      1. Frank
      2. Sandrito
      3. Davis
      4. Gintoki
    """

    random_team = RandomTeam.new(list: @list, players_per_team: 2)

    assert_includes random_team.missing_players, "gintoki"
    assert_equal 0, random_team.teams.size
  end

  test "include friends and avoids when generate teams" do
    @frank_player.friends << @sandrito_player
    @frank_player.avoids << @davis_player

    random_team = RandomTeam.new(list: @list, players_per_team: 2)
    random_team.generate!

    # TODO: Improve team generation reliability
    assert_equal 2, random_team.teams.size

    frank_player_team = random_team.teams.find { |team| team.pluck(:id).include?(@frank_player.id) }

    assert_includes frank_player_team, @sandrito_player
    refute_includes frank_player_team, @davis_player
  end

  test "only include friends who are present in the list" do
    @frank_player.friends << @sandrito_player
    @frank_player.friends << players(:spectre)

    random_team = RandomTeam.new(list: @list, players_per_team: 2)
    random_team.generate!

    # TODO: Improve team generation reliability
    assert_equal 2, random_team.teams.size

    frank_player_team = random_team.teams.find { |team| team.pluck(:id).include?(@frank_player.id) }

    assert_includes frank_player_team, @sandrito_player
    refute_includes frank_player_team, players(:spectre)
  end
end
