class EventsController < ApplicationController
  
  # Check if user is signed in before certain actions
  before_action :authenticate_user!, only: [:new, :create, :rsvp]
  def index
    @events = Event.all.order(:date)
  end

  def show
    @event = Event.find(params[:id])
  end
end
