class OnboardingsController < ApplicationController
  def show
    @user = current_user
  end

  def create
    debugger
  end
end
