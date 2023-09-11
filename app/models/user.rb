# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  admin      :boolean          default(FALSE)
#  email      :string
#  first_name :string
#  image      :string
#  last_name  :string
#  provider   :string
#  uid        :string
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  unique_usernames  (username) UNIQUE
#
class User < ApplicationRecord
  def full_name
    [first_name, last_name].join(' ')
  end


  def update_dynamic_attributes(auth)
    self.first_name = auth.info.first_name
    self.last_name = auth.info.last_name
    self.email = auth.info.email
    self.image = auth.info.image if auth.info.image?
  end

  class << self
    def find_or_create_with_omniauth(auth)
      user = find_by(auth.slice(:provider, :uid)) || initialize_from_omniauth(auth)
      user.update_dynamic_attributes(auth)
      user.save!
      user
    end

    def initialize_from_omniauth(auth)
      User.new(provider: auth.provider, uid: auth.uid)
    end
  end
end

