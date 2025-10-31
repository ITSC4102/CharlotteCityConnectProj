# frozen_string_literal: true
module AuthCookies
  extend ActiveSupport::Concern

  protected

  def set_auth_cookies(access_token:, refresh_token:, expires_in:)
    cookies.encrypted[:sb_access] = {
      value: access_token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax,
      expires: expires_in.seconds.from_now
    }
    cookies.encrypted[:sb_refresh] = {
      value: refresh_token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax,
      expires: 30.days.from_now
    }
  end

  def clear_auth_cookies
    cookies.delete(:sb_access)
    cookies.delete(:sb_refresh)
  end
end
