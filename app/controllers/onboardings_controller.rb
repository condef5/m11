class OnboardingsController < ApplicationController
  def show
    @user = User.find(current_user.id)
    @user.build_player if @user.player.nil?
  end

  def update
    @user = User.find(current_user.id)
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_path, notice: 'Onboarding complete!' }
      else
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :username, :birthdate, player_attributes: [:level, :id])
    end
end
