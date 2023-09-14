# == Schema Information
#
# Table name: player_connections
#
#  id                  :bigint           not null, primary key
#  relation_type       :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  author_id           :bigint           not null
#  connected_player_id :bigint           not null
#
# Indexes
#
#  index_player_connections_on_author_id            (author_id)
#  index_player_connections_on_connected_player_id  (connected_player_id)
#  unique_player_connection_index                   (author_id,connected_player_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (author_id => players.id)
#  fk_rails_...  (connected_player_id => players.id)
#
class PlayerConnection < ApplicationRecord
  belongs_to :author, class_name: 'Player'
  belongs_to :connected_player, class_name: 'Player'

  validates :relation_type, presence: true

  enum relation_type: {
    friend: 0,
    rival: 1,
  }
end
