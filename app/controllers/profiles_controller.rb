class ProfilesController < ApplicationController
  def show
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to profile_path, notice: "Perfil actualizado!"
    else
      flash[:alert] = "No se pudo actualizar el perfil"
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :birthdate)
  end
end
