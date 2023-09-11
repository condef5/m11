# test/models/random_team_test.rb

require 'test_helper'

class RandomTeamTest < ActiveSupport::TestCase
  def setup
    @player1 = Player.create(name: 'Frank', level: 2)
    @player2 = Player.create(name: 'Sandrito', level: 2)
    @player3 = Player.create(name: 'Davis', level: 4)
    @player4 = Player.create(name: 'Vladi', level: 4)

    @list = """
      1. Frank
      2. Sandrito
      3. Davis
      4. Vladi
    """
  end

  test 'generate teams successfully with existing players' do
    random_team = RandomTeam.new(list: @list, players_per_team: 2)

    assert_equal 0, random_team.missing_players.size

    random_team.generate!

    assert_equal 2, random_team.teams.size
    [@player1, @player2, @player3, @player4].each do |player|
      assert_includes random_team.players, player
    end
  end


  test 'identify missing players before generating teams' do
    @list = """
      1. Frank
      2. Sandrito
      3. Davis
      4. Spectre
    """

    random_team = RandomTeam.new(list: @list, players_per_team: 2)

    assert_includes random_team.missing_players, 'spectre'
    assert_equal 0, random_team.teams.size
  end
end
