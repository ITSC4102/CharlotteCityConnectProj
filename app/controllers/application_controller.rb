class ApplicationController < ActionController::Base
  helper_method :current_user, :signed_in?

  # Returns the current logged-in user (if any)
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Check if user is logged in
  def signed_in?
    current_user.present?
  end

  # Redirect to login page if user not logged in
  def authenticate_user!
    unless signed_in?
      redirect_to login_path, alert: "Please log in to continue."
    end
  end
end
