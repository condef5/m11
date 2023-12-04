require "application_system_test_case"

class GameDaysTest < ApplicationSystemTestCase
  setup do
    @game_day = game_days(:one)
  end

  test "visiting the index" do
    visit game_days_url
    assert_selector "h1", text: "Game days"
  end

  test "should create game day" do
    visit game_days_url
    click_on "New game day"

    fill_in "Player list", with: @game_day.player_list
    click_on "Create Game day"

    assert_text "Game day was successfully created"
    click_on "Back"
  end

  test "should update Game day" do
    visit game_day_url(@game_day)
    click_on "Edit this game day", match: :first

    fill_in "Player list", with: @game_day.player_list
    click_on "Update Game day"

    assert_text "Game day was successfully updated"
    click_on "Back"
  end

  test "should destroy Game day" do
    visit game_day_url(@game_day)
    click_on "Destroy this game day", match: :first

    assert_text "Game day was successfully destroyed"
  end
end
