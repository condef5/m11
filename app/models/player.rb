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
  validates :level, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :name, presence: true
end
