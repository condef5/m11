class UsersController < ApplicationController
  def index
    @users = User.joins(:player).merge(
      Player.order(level: :desc)
    )
  end
end
