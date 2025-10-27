class PagesController < ApplicationController
  def home
  end

  def dashboard
    @user_events = []  # placeholder array for testing
  end
end
