#!/usr/bin/env ruby
# Weekly Rating Update Script
# This script demonstrates how to update driver and constructor ratings
# after each race using real data from RacingNews365

require_relative 'config/environment'

puts "🏎️ Fantasy F1 League - Weekly Rating Update"
puts "=" * 50

# Step 1: Check for new race results from RacingNews365
puts "\n1. Checking for new race results from RacingNews365..."
result = F1DataService.check_for_new_race_results

if result[:success]
  if result[:race]
    puts "✅ New race results found: #{result[:race]}"
    puts "📊 #{result[:message]}"
  else
    puts "ℹ️ No new race results found"
    puts "📅 Last checked: #{result[:last_checked]&.strftime('%Y-%m-%d %H:%M')}"
  end
else
  puts "❌ Error checking for new results: #{result[:error]}"
end

# Step 2: Update standings from RacingNews365
puts "\n2. Updating championship standings from RacingNews365..."
standings_result = F1DataService.update_standings_from_racingnews365

if standings_result[:success]
  puts "✅ Standings updated successfully!"
  puts "👥 Drivers updated: #{standings_result[:drivers_updated]}"
  puts "🏭 Constructors updated: #{standings_result[:constructors_updated]}"
  puts "🕐 Last updated: #{standings_result[:last_updated].strftime('%Y-%m-%d %H:%M')}"
else
  puts "❌ Error updating standings: #{standings_result[:error]}"
end

# Step 3: Show updated ratings summary
puts "\n3. Updated Ratings Summary"
puts "-" * 30

puts "\n🏁 Top 5 Drivers:"
Driver.order(current_rating: :desc).limit(5).each do |driver|
  puts "  #{driver.name}: #{driver.current_rating} (#{driver.current_price}M) - P#{driver.championship_position}"
end

puts "\n🏭 Top 5 Constructors:"
Constructor.order(current_rating: :desc).limit(5).each do |constructor|
  puts "  #{constructor.name}: #{constructor.current_rating} (#{constructor.current_price}M) - P#{constructor.championship_position}"
end

puts "\n✅ Weekly rating update completed!"
puts "📊 All ratings are now based on current championship standings from RacingNews365"
puts "🔄 Next update should be after the next race weekend"
