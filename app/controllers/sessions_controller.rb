class SessionsController < ApplicationController
  def create
    user = User.find_or_create_with_omniauth(request.env['omniauth.auth'])
    session[:user_id] = user.id

    if user.player.blank?
      redirect_to onboarding_path, notice: "Welcome #{user.name}"
    else
      redirect_to after_sign_in_path, notice: "Signed in as #{user.name}"
    end
  end

  def failure
    redirect_to root_url, alert: 'Authentication failed.'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Signed out'
  end

  private

  def after_sign_in_path
    request.env['omniauth.params']['after_sign_in_path'] || request.env['omniauth.origin'] || home_path
  end
end
