class Players::AutocompletesController < ApplicationController
  def index
    @players = Player.search_name(params[:q]).limit(5)
    render layout: false
  end
end
