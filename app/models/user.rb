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
end

