class ApplicationController < ActionController::Base
  include Pagy::Backend

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    redirect_to root_path, alert: 'You need to sign in before continuing.' unless current_user
  end

  def success_notice(action, model)
    t(action, model: model.class.model_name.human, scope: "activerecord.success")
  end
end
