class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  private

  def logged_in?
    !!current_user
  end

  def authenticate_user!
    unless logged_in?
      redirect_to login_path, alert: "ログインしてください。"
    end
  end
end
