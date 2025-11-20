class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # Shows all events
  def index
    @events = Event.all.order(time: :asc)
  end

  # Shows events created by the current user
  def my_events
    @events = current_user.events.order(time: :asc)
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

def register
  event = Event.find(params[:id])

  # Initialize if nil
  current_user.reg_events ||= []

  unless current_user.reg_events.include?(event.id)
    current_user.reg_events << event.id
    current_user.save
  end

  redirect_to events_path, notice: "Registered for #{event.name}!"
end

def unregister
  event = Event.find(params[:id])

  if current_user.reg_events&.include?(event.id)
    current_user.reg_events.delete(event.id)
    current_user.save
  end

  redirect_to events_path, notice: "You have unregistered from #{event.name}."
end

  private

  def set_event
    @event = Event.find_by(id: params[:id])
    redirect_to events_path, alert: "Event not found." unless @event
  end

  def event_params
    params.require(:event).permit(:name, :attendees, :location, :time, :required_tags, :description)
  end
end
