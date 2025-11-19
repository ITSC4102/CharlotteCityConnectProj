class Event < ApplicationRecord
  # only these actually need to be passed to supabase, supabase handles the rest automatically
  validates :name, :attendees, :location, :time, :description, presence: true
end