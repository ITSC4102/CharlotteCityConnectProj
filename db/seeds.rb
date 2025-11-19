# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Event.create!(
  name: "CCI Hackathon",
  attendees: 120,
  location: "Woodward 106",
  time: DateTime.new(2025, 3, 10, 9, 0, 0),
  required_tags: "cci",
  description: "Info meething for CCI Hackathon event.",
)

Event.create!(
  name: "UNCC Plant Day",
  attendees: 60,
  location: "UNCC Botanical Gardens",
  time: DateTime.new(2025, 3, 10, 9, 0, 0),
  required_tags: "",
  description: "A day to explore and learn about various plant species at the UNCC Botanical Gardens.",
)