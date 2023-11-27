require "test_helper"

class GameDaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_day = game_days(:one)
  end

  test "should get index" do
    get game_days_url
    assert_response :success
  end

  test "should get new" do
    get new_game_day_url
    assert_response :success
  end

  test "should create game_day" do
    assert_difference("GameDay.count") do
      post game_days_url, params: { game_day: { player_list: @game_day.player_list } }
    end

    assert_redirected_to game_day_url(GameDay.last)
  end

  test "should show game_day" do
    get game_day_url(@game_day)
    assert_response :success
  end

  test "should get edit" do
    get edit_game_day_url(@game_day)
    assert_response :success
  end

  test "should update game_day" do
    patch game_day_url(@game_day), params: { game_day: { player_list: @game_day.player_list } }
    assert_redirected_to game_day_url(@game_day)
  end

  test "should destroy game_day" do
    assert_difference("GameDay.count", -1) do
      delete game_day_url(@game_day)
    end

    assert_redirected_to game_days_url
  end
end
