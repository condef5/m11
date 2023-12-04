# test/models/random_team_test.rb

require "test_helper"

class RandomTeamFormTest < ActiveSupport::TestCase
  def setup
    @frank_player = Player.create(name: "Frank", level: 4)
    @sandrito_player = Player.create(name: "Sandrito", level: 4)
    @davis_player = Player.create(name: "Davis", level: 4)
    @vladi_player = Player.create(name: "Vladi", level: 4)
  end

  test "validates the duplicate players" do
    list = "1. Frank\n2. Sandrito\n3. Davis\n4. Frank"
    form = RandomTeamForm.new(list: list, players_per_team: 2)

    form.save

    assert_equal ["Frank"], form.duplicated_players
    assert_equal ["tiene duplicados"], form.errors[:list]
  end

  test "validates the missing players" do
    list = "1. Frank\n2. Lucas\n3. Davis\n4. Nujabes"
    form = RandomTeamForm.new(list: list, players_per_team: 2)

    form.save

    assert_equal ["Lucas", "Nujabes"], form.missing_players
    assert_equal ["contiene jugadores no válidos"], form.errors[:list]
  end

  test "validates players per team" do
    list = "1. Frank\n2. Sandrito\n3. Davis\n4. Vladi"
    form = RandomTeamForm.new(list: list, players_per_team: 3)

    form.save

    assert_equal ["debe ser divisible por el total de jugadores"], form.errors[:players_per_team]
  end

  test "validates players per team should not bet greather than players" do
    list = "1. Frank\n2. Sandrito\n3. Davis\n4. Vladi"
    form = RandomTeamForm.new(list: list, players_per_team: 10)

    form.save

    assert_equal ["debe ser mayor que los jugadores por equipo"], form.errors[:list]
  end

  test "save list and player_per_team in game_day" do
    list = "1. Frank\n2. Sandrito\n3. Davis\n4. Vladi"
    form = RandomTeamForm.new(list: list, players_per_team: 2)
    form.game_day = GameDay.current

    form.save

    assert_equal 0, form.errors.size
    assert_equal list, GameDay.last.player_list
  end
end
