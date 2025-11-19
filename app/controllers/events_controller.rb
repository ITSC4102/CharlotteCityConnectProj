class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # Show ONLY the events that belong to the current logged-in user
  def index
    @events = current_user.events
  end

  def show
  end

  def new
    @event = current_user.events.new
  end

  def create
    @event = current_user.events.new(event_params)

    if @event.save
      redirect_to events_path, notice: "Event created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to events_path, notice: "Event updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Event deleted."
  end

  private

  def set_event
    @event = current_user.events.find_by(id: params[:id])
    redirect_to events_path, alert: "Event not found." unless @event
  end

  def event_params
    params.require(:event).permit(:title, :description, :date, :location)
  end
end
