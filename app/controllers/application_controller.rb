class ApplicationController < ActionController::Base
  helper_method :current_user, :signed_in?

  # Rails session-based current user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def signed_in?
    current_user.present?
  end

  def authenticate_user!
    unless signed_in?
      redirect_to login_path, alert: "Please log in to continue."
    end
  end
end
