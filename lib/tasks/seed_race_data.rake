namespace :db do
  namespace :seed do
    desc "Seed race data (races, driver results, constructor results, qualifying results)"
    task race_data: :environment do
      puts "🌍 Starting race data seeding..."
      
      # Load the race data seeds file
      load Rails.root.join('db', 'seeds_race_data.rb')
      
      puts "✅ Race data seeding completed!"
    end
    
    desc "Seed all data (base data + race data)"
    task all: :environment do
      puts "🚀 Starting complete data seeding..."
      
      # First run the main seeds
      puts "📦 Running main seeds..."
      load Rails.root.join('db', 'seeds.rb')
      
      # Then run the race data seeds
      puts "🏁 Running race data seeds..."
      load Rails.root.join('db', 'seeds_race_data.rb')
      
      puts "🎉 Complete data seeding finished!"
    end
  end
end
