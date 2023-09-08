# == Schema Information
#
# Table name: players
#
#  id         :bigint           not null, primary key
#  level      :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Player < ApplicationRecord
end
