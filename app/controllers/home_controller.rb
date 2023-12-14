class HomeController < ApplicationController
  def index
    if current_user
      render 'feed/index'
    end
  end
end
