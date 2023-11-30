class RandomTeamsController < ApplicationController
  def index
    @random_team = RandomTeam.new(players_per_team: 7, list: session[:list] || "")
  end

  def create
    @random_team = RandomTeam.new(random_team_params)
    session[:list] = @random_team.list

    if @random_team.missing_players.any?
      flash.now[:error] = 'Missing players in the list.'

      render :index, status: :unprocessable_entity
    else
      @random_team.generate!
      flash.now[:success] = 'Random teams were successfully created.'

      render :index,  status: :unprocessable_entity
    end
  end

  private

  def random_team_params
    params.require(:random_team).permit(:list, :players_per_team, :max_generation_attemps, :gap)
  end
end
