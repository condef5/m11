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
require "test_helper"

class PlayerConnectionTest < ActiveSupport::TestCase
  def setup
    @author = players(:lucas)
    @connected_player = players(:spike)
  end

  test "valid player_connection" do
    player_connection = PlayerConnection.new(
      relation_type: :friend, author: @author, connected_player: @connected_player,
    )

    assert player_connection.valid?
  end

  test "invalid without relation_type" do
    player_connection = PlayerConnection.new(author: @author, connected_player: @connected_player)

    assert_not player_connection.valid?, "The player_connection should be invalid"
  end

  test "only one relation type by author and connected player" do
    @author.player_connections.create(
      relation_type: :friend, connected_player: @connected_player
    )

    assert_raises(ActiveRecord::RecordInvalid) do
      @author.player_connections.create!(
        relation_type: :friend,
        connected_player: @connected_player
      )
    end
  end
end
