class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user_claims, :signed_in?

  # Check for a currently signed-in user
  def signed_in?
    current_user_claims.present?
  end

  def authenticate_user!
    unless signed_in?
      redirect_to login_path, alert: "Please log in"
    end
  end

  def current_user_claims
    @current_user_claims ||= begin
      token = cookies.encrypted[:sb_access]
      if token
        claims = SupabaseAuth.verify_jwt(token)
        return claims if clarims && Time.at(claims["exp"]) > Time.now
      end
      try_refresh_session!
    end
  end

  private

  def try_refresh_session!
    refresh = cookies.encrypted[:sb_refresh]
    return nil unless refresh

    begin
      response = SupabaseAuth.refresh_session(refresh_token: refresh)
      tokens = JSON.parse(response.body)
      SessionsController.new.set_auth_cookies(
        access_token: tokens["access_token"],
        refresh_token: tokens["refresh_token"] || refresh,
        expires_in: tokens["expires_in"]
      )
      SupabaseAuth.verify_jwt(tokens["access_token"])

      rescue Faraday::Error, NoMethodError
        cookies.delete(:sb_access)
        cookies.delete(:sb_refresh)
        nil
      end
    end
end
