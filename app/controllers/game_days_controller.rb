class GameDaysController < ApplicationController
  before_action :set_game_day, only: %i[ show edit update destroy ]

  def index
    @game_days = GameDay.order(created_at: :desc)
  end

  def show
  end

  def new
    @game_day = GameDay.new(player_list: session[:player_list])
    @validator = nil
  end

  def edit
    @validator = GameDay::ListValidator.new(list: @game_day.player_list)
  end

  def create
    @game_day = GameDay.new(game_day_params)
    @validator = GameDay::ListValidator.new(list: @game_day.player_list)
    session[:player_list] = @game_day.player_list

    respond_to do |format|
      if @game_day.save && @validator.valid?
        format.html { redirect_to game_day_url(@game_day), notice: "Game day was successfully created." }
        format.json { render :show, status: :created, location: @game_day }
      else
        # add message notice with unvalid players
        flash.now[:notice] = "Invalid players"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game_day.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @game_day.update(game_day_params)
    @validator = GameDay::ListValidator.new(list: @game_day.player_list)
    respond_to do |format|
      if @validator.valid?
        format.html { redirect_to game_day_url(@game_day), notice: "Game day was successfully updated." }
        format.json { render :show, status: :ok, location: @game_day }
      else
        flash.now[:notice] = "Invalid players"
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game_day.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @game_day.destroy!

    respond_to do |format|
      format.html { redirect_to game_days_url, notice: "Game day was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_game_day
      @game_day = GameDay.find(params[:id])
    end

    def game_day_params
      params.require(:game_day).permit(:player_list)
    end
end
