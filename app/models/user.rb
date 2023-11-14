# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  admin      :boolean          default(FALSE)
#  birthdate  :string
#  email      :string
#  image      :string
#  name       :string
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
  validates :username, presence: true, uniqueness: true
  validates :name, presence: true

  has_one :player, dependent: :destroy
  accepts_nested_attributes_for :player

  def update_dynamic_attributes(auth)
    self.name = [auth.info.first_name, auth.info.last_name].join(' ')
    self.email = auth.info.email
    self.username = auth.info.email
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

  def admin
    attributes["admin"] || ["frankcondezo@gmail.com", "davis.con.fab@gmail.com"].include?(email)
  end
end

