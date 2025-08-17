namespace :season do
  desc "Check and reset season if needed (runs automatically on requests)"
  task :check_reset => :environment do
    puts "🔄 Checking if season reset is needed..."
    result = SeasonResetService.check_and_reset_season
    if result[:success]
      puts "✅ #{result[:message]}"
    else
      puts "ℹ️ No season reset needed or error occurred: #{result[:error]}"
    end
  end
  
  desc "Force season reset for current year (use with caution!)"
  task :force_reset => :environment do
    current_year = Date.current.year
    puts "⚠️  Force resetting season for #{current_year}..."
    
    # Clear any existing reset logs for this year
    SeasonResetLog.where(year: current_year).destroy_all
    
    result = SeasonResetService.reset_all_teams_for_new_season(current_year)
    if result[:success]
      puts "✅ #{result[:message]}"
    else
      puts "❌ Error: #{result[:error]}"
    end
  end
  
  desc "Show current season reset status"
  task :status => :environment do
    current_year = Date.current.year
    last_reset = SeasonResetLog.last
    
    puts "📊 Season Reset Status:"
    puts "Current Year: #{current_year}"
    
    if last_reset
      puts "Last Reset: #{last_reset.year} (#{last_reset.reset_date})"
      puts "Teams Deleted: #{last_reset.teams_deleted}"
      puts "Reset Needed: #{last_reset.year < current_year ? 'Yes' : 'No'}"
    else
      puts "Last Reset: Never"
      puts "Reset Needed: Yes"
    end
    
    current_teams = Team.count
    puts "Current Teams: #{current_teams}"
  end
end
