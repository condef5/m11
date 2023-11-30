class RandomTeamsController < ApplicationController
  def index
    @random_team = RandomTeam.new(players_per_team: session[:players_per_team], list: session[:list] || "")
    @validator =  GameDay::ListValidator.new(list: session[:list] || "")
  end

  def create
    @random_team = RandomTeam.new(random_team_params)
    @validator = GameDay::ListValidator.new(list: @random_team.list)
    session[:list] = @random_team.list
    session[:players_per_team] = @random_team.players_per_team

    if @validator.valid?
      @random_team.generate!
      flash.now[:success] = 'Random teams were successfully created.'

      render :index, status: :unprocessable_entity
    else
      flash.now[:alert] = 'Missing players in the list.'
      render :index,  status: :unprocessable_entity
    end
  end

  private

  def random_team_params
    params.require(:random_team).permit(:list, :players_per_team, :max_generation_attemps, :gap)
  end
end
