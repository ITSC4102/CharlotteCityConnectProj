class Event < ApplicationRecord
  belongs_to :user, optional: true
  # only these actually need to be passed to supabase, supabase handles the rest automatically
  validates :name, :attendees, :location, :time, :description, presence: true
end