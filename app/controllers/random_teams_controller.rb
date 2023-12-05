class RandomTeamsController < ApplicationController
  def index
    @game_day = GameDay.current
    @form = RandomTeamForm.new(players_per_team: @game_day.players_per_team, list: @game_day.player_list)
    @form.game_day = @game_day
  end

  def create
    @form = RandomTeamForm.new(random_team_params)
    @game_day = GameDay.current
    @form.game_day = @game_day
    @game_day.update(player_list: random_team_params[:list], players_per_team: random_team_params[:players_per_team])
    @game_day.teams = []

    if @form.save
      random_team = RandomTeam.new(
        players: @game_day.players,
        **random_team_params.except(:list).to_h.symbolize_keys
      )

      @teams = random_team.generate

      if @teams.any?
        @game_day.save_teams_and_increase_attemps(@teams)
        flash.now[:notice] = 'Se crearon equipos aleatorios con éxito.'
      else
        flash.now[:alert] = 'No se pudo generar los equipos, cambiar los parámetros e intentar de nuevo'
      end
    end

    render :index, status: :unprocessable_entity
  end

  private

  def random_team_params
    params.require(:random_team).permit(:list, :players_per_team, :max_generation_attemps, :gap)
  end
end
