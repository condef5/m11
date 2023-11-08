class OnboardingsController < ApplicationController
  def show
    @user = current_user
    @user.build_player
  end

  def update
    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to root_path, notice: 'Onboarding complete!' }
      else
        @user = current_user
        @user.build_player

        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :username, player_attributes: [:level])
    end
end
