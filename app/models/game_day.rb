# == Schema Information
#
# Table name: game_days
#
#  id          :bigint           not null, primary key
#  player_list :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class GameDay < ApplicationRecord
end