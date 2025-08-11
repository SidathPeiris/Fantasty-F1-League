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
    @has_team = current_user.has_team?
  end

  def my_team
    require_login
    @user_team = current_user.current_team
    
    # Debug logging
    if @user_team
      Rails.logger.info "User team found: #{@user_team.id}"
      Rails.logger.info "Team selections count: #{@user_team.team_selections.count}"
      Rails.logger.info "Driver selections: #{@user_team.team_selections.where(selectable_type: 'Driver').count}"
      Rails.logger.info "Constructor selections: #{@user_team.team_selections.where(selectable_type: 'Constructor').count}"
    end
    
    @popular_drivers = Driver.popular
    @popular_constructors = Constructor.popular
  end
  
  def create_team
    require_login
    
    # Check if user already has a team
    if current_user.has_team?
      redirect_to dashboard_path, alert: "You already have a team! You can only create one team per user."
      return
    end
    
    @all_drivers = Driver.order(:current_price).reverse_order
    @all_constructors = Constructor.order(:current_price).reverse_order
    @selected_drivers = []
    @selected_constructor = nil
    @total_budget = 100 # Starting budget in millions
    @remaining_budget = @total_budget
  end
  
  def create_team_submit
    require_login
    
    # Check if user already has a team
    if current_user.has_team?
      render json: { success: false, message: "You already have a team! You can only create one team per user." }, status: 400
      return
    end
    
    # Get the user's selections
    drivers_param = params[:drivers] || ""
    constructor = params[:constructor]
    
    # Parse comma-separated driver IDs
    drivers = drivers_param.split(',').map(&:strip).reject(&:blank?)
    
    # Simple database save - create team and selections
    begin
      # Create the team
      team = current_user.teams.create!(
        name: "#{current_user.username}'s Team",
        total_cost: 0, # Will be calculated below
        status: 'active'
      )
      
      # Get selected drivers and constructor
      selected_drivers = Driver.where(id: drivers)
      selected_constructor = Constructor.find(constructor)
      
      # Create team selections for drivers
      selected_drivers.each do |driver|
        team.team_selections.create!(
          selectable: driver,
          cost: driver.current_price
        )
      end
      
      # Create team selection for constructor
      team.team_selections.create!(
        selectable: selected_constructor,
        cost: selected_constructor.current_price
      )
      
      # Update total cost
      total_cost = team.team_selections.sum(:cost)
      team.update!(total_cost: total_cost)
      
      # Log success
      Rails.logger.info "Team saved for user #{current_user.username}: #{team.name} with total cost $#{total_cost}M"
      
      # Return success response (no redirect)
      render json: { success: true, message: "Team saved successfully! Total cost: $#{total_cost}M" }
      
    rescue => e
      Rails.logger.error "Failed to save team for user #{current_user.username}: #{e.message}"
      render json: { success: false, message: "Failed to save team: #{e.message}" }, status: 500
    end
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
    
    # Remove automatic rating updates - ratings should only change after actual races
    # F1DataService.update_all_ratings!  # REMOVED: This was causing constant rating changes
    
    @summary = F1DataService.get_rating_changes_summary
    @races = Race.order(date: :desc).limit(5)
    @ratings_updated = false  # Changed to false since we're not auto-updating
  end

  def update_standings
    require_login
    unless current_user.username == "SidathPeiris"
      redirect_to dashboard_path, alert: "Access denied. Admin privileges required."
      return
    end
    
    # Update standings from RacingNews365
    standings_update = F1DataService.update_standings_from_racingnews365
    
    # Only update ratings if there are actual new race results
    # This prevents constant rating changes when no new data is available
    if standings_update[:success] && standings_update[:new_results]
      F1DataService.update_all_ratings!
      redirect_to admin_path, notice: "✅ Standings updated successfully! New race results found and all ratings have been refreshed."
    else
      redirect_to admin_path, notice: "ℹ️ Standings checked. No new race results found. Ratings remain unchanged."
    end
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
        # New race results were found and imported - update ratings
        F1DataService.update_all_ratings!
        redirect_to admin_path, notice: "✅ New race results found and imported! #{result[:message]} Ratings have been updated."
      else
        redirect_to admin_path, notice: "ℹ️ No new race results found. Last checked: #{result[:last_checked]&.strftime('%Y-%m-%d %H:%M')}"
      end
    else
      redirect_to admin_path, alert: "❌ Error checking for new results: #{result[:error]}"
    end
  end
end
