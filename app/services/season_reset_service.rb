class SeasonResetService
  def self.check_and_reset_season
    current_year = Date.current.year
    
    # Check if we need to reset teams for the new year
    if should_reset_season?(current_year)
      reset_all_teams_for_new_season(current_year)
    else
      # Return success message when no reset is needed
      {
        success: true,
        message: "No season reset needed for #{current_year}. Teams are current.",
        year: current_year,
        teams_deleted: 0
      }
    end
  end
  
  def self.should_reset_season?(year)
    # Check if we've already reset for this year
    last_reset = SeasonResetLog.last
    return true if last_reset.nil?
    
    last_reset.year < year
  end
  
  def self.reset_all_teams_for_new_season(year)
    puts "🔄 Starting annual team reset for #{year} season..."
    
    # Delete all existing teams
    teams_deleted = Team.count
    Team.destroy_all
    
    # Clear all season reset messages
    SeasonResetMessage.destroy_all
    
    # Clear first race dates for the new year
    FirstRaceDate.where(season_year: year).destroy_all
    
    # Log the reset
    SeasonResetLog.create!(year: year, teams_deleted: teams_deleted, reset_date: Date.current)
    
    puts "✅ Annual team reset completed for #{year} season. #{teams_deleted} teams deleted."
    
    # Return info for admin notification
    {
      success: true,
      year: year,
      teams_deleted: teams_deleted,
      message: "Annual team reset completed for #{year} season. #{teams_deleted} teams deleted."
    }
  rescue => e
    puts "❌ Error during annual team reset: #{e.message}"
    {
      success: false,
      error: e.message
    }
  end
  
  def self.should_show_season_reset_message?(user)
    current_year = Date.current.year
    
    # Check if user has already seen the message for this season
    existing_message = SeasonResetMessage.find_by(user: user, season_year: current_year)
    return false if existing_message&.message_shown
    
    # Check if user had a team in the previous season
    had_team_last_season = user.teams.exists?
    
    # Show message if they had a team last season and haven't seen this season's message
    had_team_last_season
  end
  
  def self.mark_season_reset_message_shown(user)
    current_year = Date.current.year
    
    SeasonResetMessage.find_or_create_by(user: user, season_year: current_year) do |message|
      message.message_shown = true
    end
  end
end
