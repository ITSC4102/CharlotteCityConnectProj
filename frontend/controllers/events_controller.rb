class EventsController < ApplicationController
  def index
    @events = [
      OpenStruct.new(name: "Campus Fair", date: Date.parse("2025-11-15"), venue: "UNC Charlotte Quad", spots_left: 50),
      OpenStruct.new(name: "Charlotte Festival", date: Date.parse("2025-11-20"), venue: "Uptown Charlotte", spots_left: 200)
    ]
  end

  def show
    @event = OpenStruct.new(name: "Campus Fair", date: Date.parse("2025-11-15"), venue: "UNC Charlotte Quad", spots_left: 50, description: "Meet clubs and organizations, discover new opportunities!")
  end

  def rsvp
    redirect_to event_path(params[:id]), notice: "RSVP successful!"
  end
end

