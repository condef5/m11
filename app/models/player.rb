# == Schema Information
#
# Table name: players
#
#  id         :bigint           not null, primary key
#  level      :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_players_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Player < ApplicationRecord
  validates :level, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  # validates :name, presence: true

  belongs_to :user, optional: true
  has_many :player_connections, foreign_key: :author_id, dependent: :destroy
  has_many :friends, -> { where(player_connections: { relation_type: :friend }) },
    through: :player_connections, source: :connected_player
  has_many :avoids, -> { where(player_connections: { relation_type: :rival }) },
    through: :player_connections, source: :connected_player
end
