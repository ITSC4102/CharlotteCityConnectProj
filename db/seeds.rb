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

Event.create!(
  name: "Coffee & Munchkins Morning!",
  attendees: 40,
  location: "Greek Village House 10",
  time: DateTime.new(2025, 11, 24, 8, 0, 0 ),
  required_tags: "",
  description: "Come enjoy fresh-brewed coffee (hotor iced Americanos) and Dunkin' Munchkins — our treat to you!",
)

Event.create!(
  name: "Finals Study Cart",
  attendees: 0,
  location: "Belk Hall",
  time: DateTime.new(2025, 11, 24, 8, 0, 0),
  required_tags: "",
  description: "Delivering study supplies to help de-stress! :)",
)

Event.create!(
  name: "Hot Chocolate Fundraiser for FIRST Robotics",
  attendees: 12,
  location: "Union Front Porch",
  time: DateTime.new(2026, 1, 12, 12, 0, 0),
  required_tags: "",
  description: "Sisters of Alpha Omega Epsilon hosted a hot chocolate fundraiser to support our philanthropy efforts.",
)

Event.create!(
  name: "Comedy Night",
  attendees: 18,
  location: "Friday Hall 132",
  time: DateTime.new(2025, 1, 25, 6, 0, 0),
  required_tags: "",
  description: "De-stress before exam season with Pakka Telugu for an hour of iconic Tollywood Comedy Scenes!",
)
