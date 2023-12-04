# == Schema Information
#
# Table name: game_days
#
#  id                  :bigint           not null, primary key
#  generation_attempts :integer          default(0)
#  player_list         :text
#  players_per_team    :integer          default(7)
#  teams               :jsonb            not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require "test_helper"

class GameDayTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
