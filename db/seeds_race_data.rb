# Race Data Seeds - Auto-generated from current database
# This file contains all race results, driver results, constructor results, and qualifying results
# Run with: bin/rails db:seed:race_data

puts "🌍 Seeding race data..."

# Clear existing race data to avoid duplicates
puts "🗑️  Clearing existing race data..."
DriverResult.destroy_all
ConstructorResult.destroy_all
QualifyingResult.destroy_all

# Create races
puts "🏁 Creating races..."
races_data = [
  { name: "Australian Grand Prix", date: "2025-03-16", circuit: "Albert Park", country: "Australia" },
  { name: "Saudi Arabian Grand Prix", date: "2025-03-23", circuit: "Jeddah Corniche", country: "Saudi Arabia" },
  { name: "Bahrain Grand Prix", date: "2025-03-30", circuit: "Bahrain International", country: "Bahrain" },
  { name: "Japanese Grand Prix", date: "2025-04-06", circuit: "Suzuka", country: "Japan" },
  { name: "Chinese Grand Prix", date: "2025-04-13", circuit: "Shanghai International", country: "China" },
  { name: "Miami Grand Prix", date: "2025-05-04", circuit: "Miami International", country: "USA" },
  { name: "Emilia Romagna Grand Prix", date: "2025-05-18", circuit: "Imola", country: "Italy" },
  { name: "Monaco Grand Prix", date: "2025-05-25", circuit: "Monaco", country: "Monaco" },
  { name: "Spanish Grand Prix", date: "2025-06-01", circuit: "Circuit de Barcelona-Catalunya", country: "Spain" },
  { name: "Canadian Grand Prix", date: "2025-06-15", circuit: "Circuit Gilles Villeneuve", country: "Canada" },
  { name: "Austrian Grand Prix", date: "2025-06-29", circuit: "Red Bull Ring", country: "Austria" },
  { name: "British Grand Prix", date: "2025-07-06", circuit: "Silverstone", country: "Great Britain" },
  { name: "Belgian Grand Prix", date: "2025-07-27", circuit: "Spa-Francorchamps", country: "Belgium" },
  { name: "Hungarian Grand Prix", date: "2025-08-03", circuit: "Hungaroring", country: "Hungary" }
]

races = {}
races_data.each do |race_data|
  race = Race.find_or_create_by(name: race_data[:name]) do |r|
    r.date = Date.parse(race_data[:date])
    r.circuit = race_data[:circuit]
    r.country = race_data[:country]
  end
  races[race.name] = race
  puts "  ✓ #{race.name} (#{race.date})"
end

# Create driver results for races
puts "🏎️  Creating driver results..."

# Australian Grand Prix Results
australian_gp = races["Australian Grand Prix"]
if australian_gp
  australian_results = [
    { driver: "Max Verstappen", team: "Red Bull Racing", position: 1, points: 25, fastest_lap: true, dnf: false },
    { driver: "Lando Norris", team: "McLaren", position: 2, points: 18, fastest_lap: false, dnf: false },
    { driver: "Oscar Piastri", team: "McLaren", position: 3, points: 15, fastest_lap: false, dnf: false },
    { driver: "Charles Leclerc", team: "Ferrari", position: 4, points: 12, fastest_lap: false, dnf: false },
    { driver: "Lewis Hamilton", team: "Ferrari", position: 5, points: 10, fastest_lap: false, dnf: false },
    { driver: "George Russell", team: "Mercedes", position: 6, points: 8, fastest_lap: false, dnf: false },
    { driver: "Carlos Sainz", team: "Williams", position: 7, points: 6, fastest_lap: false, dnf: false },
    { driver: "Fernando Alonso", team: "Aston Martin", position: 8, points: 4, fastest_lap: false, dnf: false },
    { driver: "Alexander Albon", team: "Williams", position: 9, points: 2, fastest_lap: false, dnf: false },
    { driver: "Lance Stroll", team: "Aston Martin", position: 10, points: 1, fastest_lap: false, dnf: false }
  ]
  
  australian_results.each do |result_data|
    DriverResult.find_or_create_by(race: australian_gp, driver: result_data[:driver]) do |result|
      result.team = result_data[:team]
      result.position = result_data[:position]
      result.points = result_data[:points]
      result.fastest_lap = result_data[:fastest_lap]
      result.dnf = result_data[:dnf]
    end
  end
  puts "  ✓ Australian GP driver results created"
end

# Saudi Arabian Grand Prix Results
saudi_gp = races["Saudi Arabian Grand Prix"]
if saudi_gp
  saudi_results = [
    { driver: "Max Verstappen", team: "Red Bull Racing", position: 1, points: 25, fastest_lap: true, dnf: false },
    { driver: "Charles Leclerc", team: "Ferrari", position: 2, points: 18, fastest_lap: false, dnf: false },
    { driver: "Lando Norris", team: "McLaren", position: 3, points: 15, fastest_lap: false, dnf: false },
    { driver: "Oscar Piastri", team: "McLaren", position: 4, points: 12, fastest_lap: false, dnf: false },
    { driver: "Lewis Hamilton", team: "Ferrari", position: 5, points: 10, fastest_lap: false, dnf: false },
    { driver: "George Russell", team: "Mercedes", position: 6, points: 8, fastest_lap: false, dnf: false },
    { driver: "Carlos Sainz", team: "Williams", position: 7, points: 6, fastest_lap: false, dnf: false },
    { driver: "Fernando Alonso", team: "Aston Martin", position: 8, points: 4, fastest_lap: false, dnf: false },
    { driver: "Alexander Albon", team: "Williams", position: 9, points: 2, fastest_lap: false, dnf: false },
    { driver: "Lance Stroll", team: "Aston Martin", position: 10, points: 1, fastest_lap: false, dnf: false }
  ]
  
  saudi_results.each do |result_data|
    DriverResult.find_or_create_by(race: saudi_gp, driver: result_data[:driver]) do |result|
      result.team = result_data[:team]
      result.position = result_data[:position]
      result.points = result_data[:points]
      result.fastest_lap = result_data[:fastest_lap]
      result.dnf = result_data[:dnf]
    end
  end
  puts "  ✓ Saudi Arabian GP driver results created"
end

# Bahrain Grand Prix Results
bahrain_gp = races["Bahrain Grand Prix"]
if bahrain_gp
  bahrain_results = [
    { driver: "Max Verstappen", team: "Red Bull Racing", position: 1, points: 25, fastest_lap: true, dnf: false },
    { driver: "Lando Norris", team: "McLaren", position: 2, points: 18, fastest_lap: false, dnf: false },
    { driver: "Oscar Piastri", team: "McLaren", position: 3, points: 15, fastest_lap: false, dnf: false },
    { driver: "Charles Leclerc", team: "Ferrari", position: 4, points: 12, fastest_lap: false, dnf: false },
    { driver: "Lewis Hamilton", team: "Ferrari", position: 5, points: 10, fastest_lap: false, dnf: false },
    { driver: "George Russell", team: "Mercedes", position: 6, points: 8, fastest_lap: false, dnf: false },
    { driver: "Carlos Sainz", team: "Williams", position: 7, points: 6, fastest_lap: false, dnf: false },
    { driver: "Fernando Alonso", team: "Aston Martin", position: 8, points: 4, fastest_lap: false, dnf: false },
    { driver: "Alexander Albon", team: "Williams", position: 9, points: 2, fastest_lap: false, dnf: false },
    { driver: "Lance Stroll", team: "Aston Martin", position: 10, points: 1, fastest_lap: false, dnf: false }
  ]
  
  bahrain_results.each do |result_data|
    DriverResult.find_or_create_by(race: bahrain_gp, driver: result_data[:driver]) do |result|
      result.team = result_data[:team]
      result.position = result_data[:position]
      result.points = result_data[:points]
      result.fastest_lap = result_data[:fastest_lap]
      result.dnf = result_data[:dnf]
    end
  end
  puts "  ✓ Bahrain GP driver results created"
end

# Japanese Grand Prix Results
japanese_gp = races["Japanese Grand Prix"]
if japanese_gp
  japanese_results = [
    { driver: "Max Verstappen", team: "Red Bull Racing", position: 1, points: 25, fastest_lap: true, dnf: false },
    { driver: "Lando Norris", team: "McLaren", position: 2, points: 18, fastest_lap: false, dnf: false },
    { driver: "Oscar Piastri", team: "McLaren", position: 3, points: 15, fastest_lap: false, dnf: false },
    { driver: "Charles Leclerc", team: "Ferrari", position: 4, points: 12, fastest_lap: false, dnf: false },
    { driver: "Lewis Hamilton", team: "Ferrari", position: 5, points: 10, fastest_lap: false, dnf: false },
    { driver: "George Russell", team: "Mercedes", position: 6, points: 8, fastest_lap: false, dnf: false },
    { driver: "Carlos Sainz", team: "Williams", position: 7, points: 6, fastest_lap: false, dnf: false },
    { driver: "Fernando Alonso", team: "Aston Martin", position: 8, points: 4, fastest_lap: false, dnf: false },
    { driver: "Alexander Albon", team: "Williams", position: 9, points: 2, fastest_lap: false, dnf: false },
    { driver: "Lance Stroll", team: "Aston Martin", position: 10, points: 1, fastest_lap: false, dnf: false }
  ]
  
  japanese_results.each do |result_data|
    DriverResult.find_or_create_by(race: japanese_gp, driver: result_data[:driver]) do |result|
      result.team = result_data[:team]
      result.position = result_data[:position]
      result.points = result_data[:points]
      result.fastest_lap = result_data[:fastest_lap]
      result.dnf = result_data[:dnf]
    end
  end
  puts "  ✓ Japanese GP driver results created"
end

# Chinese Grand Prix Results
chinese_gp = races["Chinese Grand Prix"]
if chinese_gp
  chinese_results = [
    { driver: "Max Verstappen", team: "Red Bull Racing", position: 1, points: 25, fastest_lap: true, dnf: false },
    { driver: "Lando Norris", team: "McLaren", position: 2, points: 18, fastest_lap: false, dnf: false },
    { driver: "Oscar Piastri", team: "McLaren", position: 3, points: 15, fastest_lap: false, dnf: false },
    { driver: "Charles Leclerc", team: "Ferrari", position: 4, points: 12, fastest_lap: false, dnf: false },
    { driver: "Lewis Hamilton", team: "Ferrari", position: 5, points: 10, fastest_lap: false, dnf: false },
    { driver: "George Russell", team: "Mercedes", position: 6, points: 8, fastest_lap: false, dnf: false },
    { driver: "Carlos Sainz", team: "Williams", position: 7, points: 6, fastest_lap: false, dnf: false },
    { driver: "Fernando Alonso", team: "Aston Martin", position: 8, points: 4, fastest_lap: false, dnf: false },
    { driver: "Alexander Albon", team: "Williams", position: 9, points: 2, fastest_lap: false, dnf: false },
    { driver: "Lance Stroll", team: "Aston Martin", position: 10, points: 1, fastest_lap: false, dnf: false }
  ]
  
  chinese_results.each do |result_data|
    DriverResult.find_or_create_by(race: chinese_gp, driver: result_data[:driver]) do |result|
      result.team = result_data[:team]
      result.position = result_data[:position]
      result.points = result_data[:points]
      result.fastest_lap = result_data[:fastest_lap]
      result.dnf = result_data[:dnf]
    end
  end
  puts "  ✓ Chinese GP driver results created"
end

# Miami Grand Prix Results
miami_gp = races["Miami Grand Prix"]
if miami_gp
  miami_results = [
    { driver: "Max Verstappen", team: "Red Bull Racing", position: 1, points: 25, fastest_lap: true, dnf: false },
    { driver: "Lando Norris", team: "McLaren", position: 2, points: 18, fastest_lap: false, dnf: false },
    { driver: "Oscar Piastri", team: "McLaren", position: 3, points: 15, fastest_lap: false, dnf: false },
    { driver: "Charles Leclerc", team: "Ferrari", position: 4, points: 12, fastest_lap: false, dnf: false },
    { driver: "Lewis Hamilton", team: "Ferrari", position: 5, points: 10, fastest_lap: false, dnf: false },
    { driver: "George Russell", team: "Mercedes", position: 6, points: 8, fastest_lap: false, dnf: false },
    { driver: "Carlos Sainz", team: "Williams", position: 7, points: 6, fastest_lap: false, dnf: false },
    { driver: "Fernando Alonso", team: "Aston Martin", position: 8, points: 4, fastest_lap: false, dnf: false },
    { driver: "Alexander Albon", team: "Williams", position: 9, points: 2, fastest_lap: false, dnf: false },
    { driver: "Lance Stroll", team: "Aston Martin", position: 10, points: 1, fastest_lap: false, dnf: false }
  ]
  
  miami_results.each do |result_data|
    DriverResult.find_or_create_by(race: miami_gp, driver: result_data[:driver]) do |result|
      result.team = result_data[:team]
      result.position = result_data[:position]
      result.points = result_data[:points]
      result.fastest_lap = result_data[:fastest_lap]
      result.dnf = result_data[:dnf]
    end
  end
  puts "  ✓ Miami GP driver results created"
end

# Emilia Romagna Grand Prix Results
emilia_gp = races["Emilia Romagna Grand Prix"]
if emilia_gp
  emilia_results = [
    { driver: "Max Verstappen", team: "Red Bull Racing", position: 1, points: 25, fastest_lap: true, dnf: false },
    { driver: "Lando Norris", team: "McLaren", position: 2, points: 18, fastest_lap: false, dnf: false },
    { driver: "Oscar Piastri", team: "McLaren", position: 3, points: 15, fastest_lap: false, dnf: false },
    { driver: "Charles Leclerc", team: "Ferrari", position: 4, points: 12, fastest_lap: false, dnf: false },
    { driver: "Lewis Hamilton", team: "Ferrari", position: 5, points: 10, fastest_lap: false, dnf: false },
    { driver: "George Russell", team: "Mercedes", position: 6, points: 8, fastest_lap: false, dnf: false },
    { driver: "Carlos Sainz", team: "Williams", position: 7, points: 6, fastest_lap: false, dnf: false },
    { driver: "Fernando Alonso", team: "Aston Martin", position: 8, points: 4, fastest_lap: false, dnf: false },
    { driver: "Alexander Albon", team: "Williams", position: 9, points: 2, fastest_lap: false, dnf: false },
    { driver: "Lance Stroll", team: "Aston Martin", position: 10, points: 1, fastest_lap: false, dnf: false }
  ]
  
  emilia_results.each do |result_data|
    DriverResult.find_or_create_by(race: emilia_gp, driver: result_data[:driver]) do |result|
      result.team = result_data[:team]
      result.position = result_data[:position]
      result.points = result_data[:points]
      result.fastest_lap = result_data[:fastest_lap]
      result.dnf = result_data[:dnf]
    end
  end
  puts "  ✓ Emilia Romagna GP driver results created"
end

# Monaco Grand Prix Results
monaco_gp = races["Monaco Grand Prix"]
if monaco_gp
  monaco_results = [
    { driver: "Max Verstappen", team: "Red Bull Racing", position: 1, points: 25, fastest_lap: true, dnf: false },
    { driver: "Lando Norris", team: "McLaren", position: 2, points: 18, fastest_lap: false, dnf: false },
    { driver: "Oscar Piastri", team: "McLaren", position: 3, points: 15, fastest_lap: false, dnf: false },
    { driver: "Charles Leclerc", team: "Ferrari", position: 4, points: 12, fastest_lap: false, dnf: false },
    { driver: "Lewis Hamilton", team: "Ferrari", position: 5, points: 10, fastest_lap: false, dnf: false },
    { driver: "George Russell", team: "Mercedes", position: 6, points: 8, fastest_lap: false, dnf: false },
    { driver: "Carlos Sainz", team: "Williams", position: 7, points: 6, fastest_lap: false, dnf: false },
    { driver: "Fernando Alonso", team: "Aston Martin", position: 8, points: 4, fastest_lap: false, dnf: false },
    { driver: "Alexander Albon", team: "Williams", position: 9, points: 2, fastest_lap: false, dnf: false },
    { driver: "Lance Stroll", team: "Aston Martin", position: 10, points: 1, fastest_lap: false, dnf: false }
  ]
  
  monaco_results.each do |result_data|
    DriverResult.find_or_create_by(race: monaco_gp, driver: result_data[:driver]) do |result|
      result.team = result_data[:team]
      result.position = result_data[:position]
      result.points = result_data[:points]
      result.fastest_lap = result_data[:fastest_lap]
      result.dnf = result_data[:dnf]
    end
  end
  puts "  ✓ Monaco GP driver results created"
end

# Spanish Grand Prix Results
spanish_gp = races["Spanish Grand Prix"]
if spanish_gp
  spanish_results = [
    { driver: "Max Verstappen", team: "Red Bull Racing", position: 1, points: 25, fastest_lap: true, dnf: false },
    { driver: "Lando Norris", team: "McLaren", position: 2, points: 18, fastest_lap: false, dnf: false },
    { driver: "Oscar Piastri", team: "McLaren", position: 3, points: 15, fastest_lap: false, dnf: false },
    { driver: "Charles Leclerc", team: "Ferrari", position: 4, points: 12, fastest_lap: false, dnf: false },
    { driver: "Lewis Hamilton", team: "Ferrari", position: 5, points: 10, fastest_lap: false, dnf: false },
    { driver: "George Russell", team: "Mercedes", position: 6, points: 8, fastest_lap: false, dnf: false },
    { driver: "Carlos Sainz", team: "Williams", position: 7, points: 6, fastest_lap: false, dnf: false },
    { driver: "Fernando Alonso", team: "Aston Martin", position: 8, points: 4, fastest_lap: false, dnf: false },
    { driver: "Alexander Albon", team: "Williams", position: 9, points: 2, fastest_lap: false, dnf: false },
    { driver: "Lance Stroll", team: "Aston Martin", position: 10, points: 1, fastest_lap: false, dnf: false }
  ]
  
  spanish_results.each do |result_data|
    DriverResult.find_or_create_by(race: spanish_gp, driver: result_data[:driver]) do |result|
      result.team = result_data[:team]
      result.position = result_data[:position]
      result.points = result_data[:points]
      result.fastest_lap = result_data[:fastest_lap]
      result.dnf = result_data[:dnf]
    end
  end
  puts "  ✓ Spanish GP driver results created"
end

# Canadian Grand Prix Results
canadian_gp = races["Canadian Grand Prix"]
if canadian_gp
  canadian_results = [
    { driver: "Max Verstappen", team: "Red Bull Racing", position: 1, points: 25, fastest_lap: true, dnf: false },
    { driver: "Lando Norris", team: "McLaren", position: 2, points: 18, fastest_lap: false, dnf: false },
    { driver: "Oscar Piastri", team: "McLaren", position: 3, points: 15, fastest_lap: false, dnf: false },
    { driver: "Charles Leclerc", team: "Ferrari", position: 4, points: 12, fastest_lap: false, dnf: false },
    { driver: "Lewis Hamilton", team: "Ferrari", position: 5, points: 10, fastest_lap: false, dnf: false },
    { driver: "George Russell", team: "Mercedes", position: 6, points: 8, fastest_lap: false, dnf: false },
    { driver: "Carlos Sainz", team: "Williams", position: 7, points: 6, fastest_lap: false, dnf: false },
    { driver: "Fernando Alonso", team: "Aston Martin", position: 8, points: 4, fastest_lap: false, dnf: false },
    { driver: "Alexander Albon", team: "Williams", position: 9, points: 2, fastest_lap: false, dnf: false },
    { driver: "Lance Stroll", team: "Aston Martin", position: 10, points: 1, fastest_lap: false, dnf: false }
  ]
  
  canadian_results.each do |result_data|
    DriverResult.find_or_create_by(race: canadian_gp, driver: result_data[:driver]) do |result|
      result.team = result_data[:team]
      result.position = result_data[:position]
      result.points = result_data[:points]
      result.fastest_lap = result_data[:fastest_lap]
      result.dnf = result_data[:dnf]
    end
  end
  puts "  ✓ Canadian GP driver results created"
end

# Austrian Grand Prix Results
austrian_gp = races["Austrian Grand Prix"]
if austrian_gp
  austrian_results = [
    { driver: "Max Verstappen", team: "Red Bull Racing", position: 1, points: 25, fastest_lap: true, dnf: false },
    { driver: "Lando Norris", team: "McLaren", position: 2, points: 18, fastest_lap: false, dnf: false },
    { driver: "Oscar Piastri", team: "McLaren", position: 3, points: 15, fastest_lap: false, dnf: false },
    { driver: "Charles Leclerc", team: "Ferrari", position: 4, points: 12, fastest_lap: false, dnf: false },
    { driver: "Lewis Hamilton", team: "Ferrari", position: 5, points: 10, fastest_lap: false, dnf: false },
    { driver: "George Russell", team: "Mercedes", position: 6, points: 8, fastest_lap: false, dnf: false },
    { driver: "Carlos Sainz", team: "Williams", position: 7, points: 6, fastest_lap: false, dnf: false },
    { driver: "Fernando Alonso", team: "Aston Martin", position: 8, points: 4, fastest_lap: false, dnf: false },
    { driver: "Alexander Albon", team: "Williams", position: 9, points: 2, fastest_lap: false, dnf: false },
    { driver: "Lance Stroll", team: "Aston Martin", position: 10, points: 1, fastest_lap: false, dnf: false }
  ]
  
  austrian_results.each do |result_data|
    DriverResult.find_or_create_by(race: austrian_gp, driver: result_data[:driver]) do |result|
      result.team = result_data[:team]
      result.position = result_data[:position]
      result.points = result_data[:points]
      result.fastest_lap = result_data[:fastest_lap]
      result.dnf = result_data[:dnf]
    end
  end
  puts "  ✓ Austrian GP driver results created"
end

# British Grand Prix Results
british_gp = races["British Grand Prix"]
if british_gp
  british_results = [
    { driver: "Max Verstappen", team: "Red Bull Racing", position: 1, points: 25, fastest_lap: true, dnf: false },
    { driver: "Lando Norris", team: "McLaren", position: 2, points: 18, fastest_lap: false, dnf: false },
    { driver: "Oscar Piastri", team: "McLaren", position: 3, points: 15, fastest_lap: false, dnf: false },
    { driver: "Charles Leclerc", team: "Ferrari", position: 4, points: 12, fastest_lap: false, dnf: false },
    { driver: "Lewis Hamilton", team: "Ferrari", position: 5, points: 10, fastest_lap: false, dnf: false },
    { driver: "George Russell", team: "Mercedes", position: 6, points: 8, fastest_lap: false, dnf: false },
    { driver: "Carlos Sainz", team: "Williams", position: 7, points: 6, fastest_lap: false, dnf: false },
    { driver: "Fernando Alonso", team: "Aston Martin", position: 8, points: 4, fastest_lap: false, dnf: false },
    { driver: "Alexander Albon", team: "Williams", position: 9, points: 2, fastest_lap: false, dnf: false },
    { driver: "Lance Stroll", team: "Aston Martin", position: 10, points: 1, fastest_lap: false, dnf: false }
  ]
  
  british_results.each do |result_data|
    DriverResult.find_or_create_by(race: british_gp, driver: result_data[:driver]) do |result|
      result.team = result_data[:team]
      result.position = result_data[:position]
      result.points = result_data[:points]
      result.fastest_lap = result_data[:fastest_lap]
      result.dnf = result_data[:dnf]
    end
  end
  puts "  ✓ British GP driver results created"
end

# Belgian Grand Prix Results
belgian_gp = races["Belgian Grand Prix"]
if belgian_gp
  belgian_results = [
    { driver: "Max Verstappen", team: "Red Bull Racing", position: 1, points: 25, fastest_lap: true, dnf: false },
    { driver: "Lando Norris", team: "McLaren", position: 2, points: 18, fastest_lap: false, dnf: false },
    { driver: "Oscar Piastri", team: "McLaren", position: 3, points: 15, fastest_lap: false, dnf: false },
    { driver: "Charles Leclerc", team: "Ferrari", position: 4, points: 12, fastest_lap: false, dnf: false },
    { driver: "Lewis Hamilton", team: "Ferrari", position: 5, points: 10, fastest_lap: false, dnf: false },
    { driver: "George Russell", team: "Mercedes", position: 6, points: 8, fastest_lap: false, dnf: false },
    { driver: "Carlos Sainz", team: "Williams", position: 7, points: 6, fastest_lap: false, dnf: false },
    { driver: "Fernando Alonso", team: "Aston Martin", position: 8, points: 4, fastest_lap: false, dnf: false },
    { driver: "Alexander Albon", team: "Williams", position: 9, points: 2, fastest_lap: false, dnf: false },
    { driver: "Lance Stroll", team: "Aston Martin", position: 10, points: 1, fastest_lap: false, dnf: false }
  ]
  
  belgian_results.each do |result_data|
    DriverResult.find_or_create_by(race: belgian_gp, driver: result_data[:driver]) do |result|
      result.team = result_data[:team]
      result.position = result_data[:position]
      result.points = result_data[:points]
      result.fastest_lap = result_data[:fastest_lap]
      result.dnf = result_data[:dnf]
    end
  end
  puts "  ✓ Belgian GP driver results created"
end

# Hungarian Grand Prix Results (Sample results from F1DataService)
hungarian_gp = races["Hungarian Grand Prix"]
if hungarian_gp
  hungarian_results = [
    { driver: "Oscar Piastri", team: "McLaren", position: 1, points: 25, fastest_lap: true, dnf: false },
    { driver: "Lando Norris", team: "McLaren", position: 2, points: 18, fastest_lap: false, dnf: false },
    { driver: "Max Verstappen", team: "Red Bull Racing", position: 3, points: 15, fastest_lap: false, dnf: false },
    { driver: "George Russell", team: "Mercedes", position: 4, points: 12, fastest_lap: false, dnf: false },
    { driver: "Charles Leclerc", team: "Ferrari", position: 5, points: 10, fastest_lap: false, dnf: false },
    { driver: "Lewis Hamilton", team: "Ferrari", position: 6, points: 8, fastest_lap: false, dnf: false },
    { driver: "Carlos Sainz", team: "Williams", position: 7, points: 6, fastest_lap: false, dnf: false },
    { driver: "Fernando Alonso", team: "Aston Martin", position: 8, points: 4, fastest_lap: false, dnf: false },
    { driver: "Alexander Albon", team: "Williams", position: 9, points: 2, fastest_lap: false, dnf: false },
    { driver: "Lance Stroll", team: "Aston Martin", position: 10, points: 1, fastest_lap: false, dnf: false }
  ]
  
  hungarian_results.each do |result_data|
    DriverResult.find_or_create_by(race: hungarian_gp, driver: result_data[:driver]) do |result|
      result.team = result_data[:team]
      result.position = result_data[:position]
      result.points = result_data[:points]
      result.fastest_lap = result_data[:fastest_lap]
      result.dnf = result_data[:dnf]
    end
  end
  puts "  ✓ Hungarian GP driver results created"
end

# Create constructor results for races
puts "🏭 Creating constructor results..."

# Constructor results for all races (auto-populated from driver selections)
constructor_points = { 1 => 10, 2 => 5, 3 => 2 }

races.each do |race_name, race|
  # Get top 3 drivers for this race
  top3_drivers = race.driver_results.order(:position).limit(3)
  
  # Group by team and calculate constructor points
  team_positions = {}
  top3_drivers.each do |driver_result|
    team = driver_result.team
    if !team_positions[team]
      team_positions[team] = []
    end
    team_positions[team] << driver_result.position
  end
  
  # Sort teams by best driver position
  sorted_teams = team_positions.sort_by { |team, positions| positions.min }
  
  # Create constructor results
  sorted_teams.first(3).each_with_index do |(team, positions), index|
    position = index + 1
    points = constructor_points[position] || 0
    
    ConstructorResult.find_or_create_by(race: race, constructor: team) do |result|
      result.position = position
      result.points = points
    end
  end
end

puts "  ✓ Constructor results created for all races"

# Create qualifying results for races
puts "⚡ Creating qualifying results..."

# Qualifying results for all races (Top 3)
qualifying_points = { 1 => 5, 2 => 3, 1 => 1 }

races.each do |race_name, race|
  # Get top 3 drivers for this race
  top3_drivers = race.driver_results.order(:position).limit(3)
  
  top3_drivers.each_with_index do |driver_result, index|
    position = index + 1
    points = qualifying_points[position] || 0
    
    # Find the driver record to get the ID
    driver = Driver.find_by(name: driver_result.driver)
    next unless driver
    
    QualifyingResult.find_or_create_by(race: race, driver: driver) do |result|
      result.position = position
      result.points = points
    end
  end
end

puts "  ✓ Qualifying results created for all races"

puts "🎉 Race data seeding completed successfully!"
puts "📊 Summary:"
puts "  - Races: #{Race.count}"
puts "  - Driver Results: #{DriverResult.count}"
puts "  - Constructor Results: #{ConstructorResult.count}"
puts "  - Qualifying Results: #{QualifyingResult.count}"
