# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seed drivers with centralized data (ratings will be calculated by the new system)
drivers = [
  { name: "Max Verstappen", team: "Red Bull Racing", base_price: 28, photo_url: "/images/drivers/max_verstappen.jpg" },
  { name: "Lando Norris", team: "McLaren", base_price: 26, photo_url: "/images/drivers/lando_norris.jpg" },
  { name: "Oscar Piastri", team: "McLaren", base_price: 24, photo_url: "/images/drivers/oscar_piastri.jpg" },
  { name: "Charles Leclerc", team: "Ferrari", base_price: 24, photo_url: "/images/drivers/charles_leclerc.jpg" },
  { name: "Lewis Hamilton", team: "Mercedes", base_price: 23, photo_url: "/images/drivers/lewis_hamilton.jpg" },
  { name: "George Russell", team: "Mercedes", base_price: 22, photo_url: "/images/drivers/george_russell.jpg" },
  { name: "Carlos Sainz", team: "Ferrari", base_price: 22, photo_url: "/images/drivers/carlos_sainz.jpg" },
  { name: "Fernando Alonso", team: "Aston Martin", base_price: 19, photo_url: "/images/drivers/fernando_alonso.jpg" }
]

drivers.each do |attrs|
  d = Driver.find_or_initialize_by(name: attrs[:name])
  d.assign_attributes(attrs)
  d.save!
end

# Seed constructors with centralized data (ratings will be calculated by the new system)
constructors = [
  { name: "Red Bull Racing", base_price: 8 },
  { name: "McLaren", base_price: 7 },
  { name: "Ferrari", base_price: 7 },
  { name: "Mercedes", base_price: 6 },
  { name: "Aston Martin", base_price: 5 },
  { name: "Williams", base_price: 4 },
  { name: "Kick Sauber", base_price: 3 },
  { name: "Haas", base_price: 3 },
  { name: "Racing Bulls", base_price: 4 },
  { name: "Alpine", base_price: 4 }
]

constructors.each do |attrs|
  c = Constructor.find_or_initialize_by(name: attrs[:name])
  c.assign_attributes(attrs)
  c.save!
end

# Update all ratings using the new rating system
puts "Updating all ratings with new system..."
F1DataService.update_all_ratings!
puts "All ratings updated successfully!"

# Note: Race data (races, results, qualifying) is seeded separately
# Run 'bin/rails db:seed:race_data' to populate race data
# Run 'bin/rails db:seed:all' to populate everything

