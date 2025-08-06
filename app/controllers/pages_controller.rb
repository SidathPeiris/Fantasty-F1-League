class PagesController < ApplicationController
  def home
  end

  def about
  end

  def features
  end

  def contact
  end

  def signup
  end

  def login
  end

  def dashboard
    require_login
  end

  def my_team
    require_login
    @popular_drivers = Driver.popular
    @popular_constructors = Constructor.popular
  end
  
  def update_ratings
    require_login
    F1DataService.update_all_ratings!
    redirect_to my_team_path, notice: "Driver and constructor ratings updated successfully!"
  end
  
  def rating_summary
    require_login
    @summary = F1DataService.get_rating_changes_summary
  end
  
  def driver_calculations
    require_login
    # Only allow SidathPeiris to access detailed calculations
    unless current_user.username == "SidathPeiris"
      redirect_to dashboard_path, alert: "Access denied. Admin privileges required."
      return
    end
    
    @driver_calculations = F1DataService.get_detailed_driver_calculations
  end
  
  def admin_panel
    require_login
    # Only allow SidathPeiris to access admin panel
    unless current_user.username == "SidathPeiris"
      redirect_to dashboard_path, alert: "Access denied. Admin privileges required."
      return
    end
    
    # Automatically update all ratings when visiting admin panel
    F1DataService.update_all_ratings!
    
    @summary = F1DataService.get_rating_changes_summary
    @races = Race.order(date: :desc).limit(5)
    @ratings_updated = true
  end

  def update_standings
    require_login
    unless current_user.username == "SidathPeiris"
      redirect_to dashboard_path, alert: "Access denied. Admin privileges required."
      return
    end
    
    # Update standings from RacingNews365 and refresh ratings
    standings_update = F1DataService.update_standings_from_racingnews365
    F1DataService.update_all_ratings!
    
    redirect_to admin_path, notice: "Standings updated successfully! All ratings and costs have been refreshed."
  end

  def check_new_results
    require_login
    unless current_user.username == "SidathPeiris"
      redirect_to dashboard_path, alert: "Access denied. Admin privileges required."
      return
    end
    
    # Check for new race results from RacingNews365
    result = F1DataService.check_for_new_race_results
    
    if result[:success]
      if result[:race]
        redirect_to admin_path, notice: "✅ New race results found and imported! #{result[:message]}"
      else
        redirect_to admin_path, notice: "ℹ️ No new race results found. Last checked: #{result[:last_checked]&.strftime('%Y-%m-%d %H:%M')}"
      end
    else
      redirect_to admin_path, alert: "❌ Error checking for new results: #{result[:error]}"
    end
  end
end
