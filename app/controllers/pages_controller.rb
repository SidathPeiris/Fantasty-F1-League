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
    return unless require_login
    
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
    return unless require_login
    
    # Debug logging
    Rails.logger.info "=== CREATE TEAM SUBMIT DEBUG ==="
    Rails.logger.info "Current user: #{current_user.username} (ID: #{current_user.id})"
    Rails.logger.info "Params received: #{params.inspect}"
    Rails.logger.info "User already has team: #{current_user.has_team?}"
    
    # Check if user already has a team
    if current_user.has_team?
      Rails.logger.info "User already has team, returning error"
      render json: { success: false, message: "You already have a team! You can only create one team per user." }, status: 400
      return
    end
    
    # Get the user's selections
    drivers_param = params[:drivers] || ""
    constructor = params[:constructor]
    
    Rails.logger.info "Drivers param: '#{drivers_param}'"
    Rails.logger.info "Constructor param: '#{constructor}'"
    
    # Parse comma-separated driver IDs
    drivers = drivers_param.split(',').map(&:strip).reject(&:blank?)
    
    Rails.logger.info "Parsed drivers: #{drivers.inspect}"
    
    # Simple database save - create team and selections
    begin
      # Create the team
      team = current_user.teams.create!(
        name: "#{current_user.username}'s Team",
        total_cost: 0, # Will be calculated below
        status: 'active'
      )
      
      Rails.logger.info "Team created: #{team.inspect}"
      
      # Get selected drivers and constructor
      selected_drivers = Driver.where(id: drivers)
      selected_constructor = Constructor.find(constructor)
      
      Rails.logger.info "Selected drivers: #{selected_drivers.map(&:name)}"
      Rails.logger.info "Selected constructor: #{selected_constructor.name}"
      
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
      Rails.logger.error "Backtrace: #{e.backtrace.first(5).join("\n")}"
      render json: { success: false, message: "Failed to save team: #{e.message}" }, status: 500
    end
  end

  def edit_team
    return unless require_login
    
    @has_team = current_user.has_team?
    
    if !@has_team
      redirect_to dashboard_path, alert: "You don't have a team to edit"
      return
    end
    
    if !can_edit_team?
      redirect_to dashboard_path, alert: "Team editing is currently locked"
      return
    end
    
    @current_team = current_user.teams.first
    @current_drivers = @current_team.drivers
    @current_constructor = @current_team.constructors.first
    
    # Calculate current balance: $100M - amount already spent
    @current_balance = 100 - @current_team.total_cost
    
    # Pass current team data to the view for React component
    @current_team_data = {
      drivers: @current_drivers.map do |d|
        {
          id: d.id,
          name: d.name,
          team: d.team,
          current_price: d.current_price,
          original_cost: @current_team.team_selections.find_by(selectable: d)&.cost || d.current_price
        }
      end,
      constructor: {
        id: @current_constructor.id,
        name: @current_constructor.name,
        current_price: @current_constructor.current_price,
        original_cost: @current_team.team_selections.find_by(selectable: @current_constructor)&.cost || @current_constructor.current_price
      },
      current_balance: @current_balance
    }
  end

  def edit_team_submit
    return unless require_login
    
    # Debug logging
    Rails.logger.info "=== EDIT TEAM SUBMIT DEBUG ==="
    Rails.logger.info "Current user: #{current_user.username} (ID: #{current_user.id})"
    Rails.logger.info "Params received: #{params.inspect}"
    
    # Check if user has a team to edit
    unless current_user.has_team?
      render json: { success: false, message: "You don't have a team to edit" }, status: 400
      return
    end
    
    # Check if team editing is allowed
    unless can_edit_team?
      render json: { success: false, message: "Team editing is currently locked" }, status: 400
      return
    end
    
    # Get the user's selections
    drivers_param = params[:drivers] || ""
    constructor = params[:constructor]
    sold_drivers = params[:sold_drivers] || ""
    sold_constructor = params[:sold_constructor]
    
    Rails.logger.info "Drivers param: '#{drivers_param}'"
    Rails.logger.info "Constructor param: '#{constructor}'"
    Rails.logger.info "Sold drivers: '#{sold_drivers}'"
    Rails.logger.info "Sold constructor: '#{sold_constructor}'"
    
    # Parse comma-separated driver IDs
    drivers = drivers_param.split(',').map(&:strip).reject(&:blank?)
    sold_drivers_list = sold_drivers.split(',').map(&:strip).reject(&:blank?)
    
    Rails.logger.info "Parsed drivers: #{drivers.inspect}"
    Rails.logger.info "Sold drivers: #{sold_drivers_list.inspect}"
    
    begin
      @current_team = current_user.teams.first
      
      # Calculate money from sold items at CURRENT MARKET VALUE
      sold_money = 0
      
      # Remove sold drivers and add current market value to budget
      sold_drivers_list.each do |driver_id|
        driver = Driver.find(driver_id)
        sold_money += driver.current_price  # Use current market value, not original cost
        driver_selection = @current_team.team_selections.find_by(selectable: driver)
        driver_selection.destroy if driver_selection
      end
      
      # Remove sold constructor and add current market value to budget
      if sold_constructor.present?
        constructor_obj = Constructor.find(sold_constructor)
        sold_money += constructor_obj.current_price  # Use current market value, not original cost
        constructor_selection = @current_team.team_selections.find_by(selectable: constructor_obj)
        constructor_selection.destroy if constructor_selection
      end
      
      # Calculate available budget: Current balance + money from sales
      current_balance = 100 - @current_team.total_cost
      available_budget = current_balance + sold_money
      
      Rails.logger.info "Current balance: $#{current_balance}M"
      Rails.logger.info "Money from sales: $#{sold_money}M"
      Rails.logger.info "Available budget: $#{available_budget}M"
      
      # Get selected drivers and constructor
      selected_drivers = Driver.where(id: drivers)
      selected_constructor = Constructor.find(constructor)
      
      # Calculate total cost of new selections
      total_cost = selected_drivers.sum(&:current_price) + selected_constructor.current_price
      
      # Check if new selections fit within budget
      if total_cost > available_budget
        render json: { success: false, message: "New team exceeds available budget of $#{available_budget}M" }, status: 400
        return
      end
      
      # Create new team selections
      selected_drivers.each do |driver|
        @current_team.team_selections.create!(
          selectable: driver,
          cost: driver.current_price
        )
      end
      
      @current_team.team_selections.create!(
        selectable: selected_constructor,
        cost: selected_constructor.current_price
      )
      
      # Update total cost
      @current_team.update!(total_cost: total_cost)
      
      # Log success
      Rails.logger.info "Team updated for user #{current_user.username}: #{@current_team.name} with total cost $#{total_cost}M"
      
      # Return success response
      render json: { 
        success: true, 
        message: "Team updated successfully! Total cost: $#{total_cost}M, Budget remaining: $#{available_budget - total_cost}M" 
      }
      
    rescue => e
      Rails.logger.error "Failed to update team for user #{current_user.username}: #{e.message}"
      Rails.logger.error "Backtrace: #{e.backtrace.first(5).join("\n")}"
      render json: { success: false, message: "Failed to update team: #{e.message}" }, status: 400
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
    begin
      F1DataService.update_standings_from_racingnews365
      redirect_to admin_panel_path, notice: "Standings updated successfully! All ratings and costs have been recalculated."
    rescue => e
      redirect_to admin_panel_path, alert: "Failed to update standings: #{e.message}"
    end
  end
  
  # Mid-Season Break Management Actions
  def set_mid_season_break
    require_login
    unless current_user.username == "SidathPeiris"
      render json: { success: false, message: "Access denied. Admin privileges required." }, status: 403
      return
    end
    
    begin
      # Clear any existing break periods
      MidSeasonBreak.destroy_all
      
      # Create new break period
      break_period = MidSeasonBreak.create!(
        start_date: params[:start_date],
        end_date: params[:end_date]
      )
      
      render json: { 
        success: true, 
        message: "Mid-season break period set successfully",
        break_period: {
          start_date: break_period.start_date,
          end_date: break_period.end_date
        }
      }
    rescue => e
      render json: { success: false, message: "Failed to set break period: #{e.message}" }, status: 500
    end
  end
  
  def clear_mid_season_break
    require_login
    unless current_user.username == "SidathPeiris"
      render json: { success: false, message: "Access denied. Admin privileges required." }, status: 403
      return
    end
    
    begin
      MidSeasonBreak.destroy_all
      render json: { success: true, message: "Mid-season break period cleared successfully" }
    rescue => e
      render json: { success: false, message: "Failed to clear break period: #{e.message}" }, status: 500
    end
  end
  
  def get_mid_season_break
    require_login
    unless current_user.username == "SidathPeiris"
      render json: { success: false, message: "Access denied. Admin privileges required." }, status: 403
      return
    end
    
    begin
      break_period = MidSeasonBreak.first
      if break_period
        render json: { 
          success: true, 
          break_period: {
            start_date: break_period.start_date,
            end_date: break_period.end_date
          }
        }
      else
        render json: { success: true, break_period: nil }
      end
    rescue => e
      render json: { success: false, message: "Failed to get break period: #{e.message}" }, status: 500
    end
  end
  
  def dismiss_season_reset_message
    require_login
    
    begin
      SeasonResetService.mark_season_reset_message_shown(current_user)
      render json: { success: true, message: "Season reset message dismissed" }
    rescue => e
      render json: { success: false, message: "Failed to dismiss message: #{e.message}" }, status: 500
    end
  end
  
  # Season Reset Management Actions
  def get_season_reset_status
    require_login
    unless current_user.username == "SidathPeiris"
      render json: { success: false, message: "Access denied. Admin privileges required." }, status: 403
      return
    end
    
    begin
      current_year = Date.current.year
      last_reset = SeasonResetLog.last
      current_teams = Team.count
      first_race = FirstRaceDate.find_by(season_year: current_year)
      
      if last_reset
        last_reset_info = "#{last_reset.year} (#{last_reset.reset_date})"
        reset_needed = last_reset.year < current_year
      else
        last_reset_info = "Never"
        reset_needed = true
      end
      
      render json: { 
        success: true, 
        current_year: current_year,
        last_reset_info: last_reset_info,
        current_teams_count: current_teams,
        reset_needed: reset_needed,
        first_race_date: first_race&.race_date
      }
    rescue => e
      render json: { success: false, message: "Failed to get season reset status: #{e.message}" }, status: 500
    end
  end
  
  def check_season_reset
    require_login
    unless current_user.username == "SidathPeiris"
      render json: { success: false, message: "Access denied. Admin privileges required." }, status: 403
      return
    end
    
    begin
      result = SeasonResetService.check_and_reset_season
      
      # Handle case where result might be nil
      if result.nil?
        render json: { success: false, message: "Service returned no result" }, status: 500
        return
      end
      
      if result[:success]
        render json: { success: true, message: result[:message] }
      else
        render json: { success: true, message: "No season reset needed or error occurred: #{result[:error]}" }
      end
    rescue => e
      render json: { success: false, message: "Failed to check season reset: #{e.message}" }, status: 500
    end
  end
  
  def force_season_reset
    require_login
    unless current_user.username == "SidathPeiris"
      render json: { success: false, message: "Access denied. Admin privileges required." }, status: 403
      return
    end
    
    begin
      current_year = Date.current.year
      
      # Clear any existing reset logs for this year
      SeasonResetLog.where(year: current_year).destroy_all
      
      result = SeasonResetService.reset_all_teams_for_new_season(current_year)
      if result[:success]
        render json: { success: true, message: result[:message] }
      else
        render json: { success: false, message: "Failed to force season reset: #{result[:error]}" }
      end
    rescue => e
      render json: { success: false, message: "Failed to force season reset: #{e.message}" }, status: 500
    end
  end
  
  # First Race Date Management Actions
  def set_first_race_date
    require_login
    unless current_user.username == "SidathPeiris"
      render json: { success: false, message: "Access denied. Admin privileges required." }, status: 403
      return
    end
    
    begin
      current_year = Date.current.year
      
      # Parse the date parameter
      race_date_param = params[:first_race_date]
      
      if race_date_param.blank?
        render json: { success: false, message: "First race date is required" }, status: 400
        return
      end
      
      # Parse the date string to a Date object
      begin
        race_date = Date.parse(race_date_param)
      rescue ArgumentError => e
        render json: { success: false, message: "Invalid date format. Please use YYYY-MM-DD format." }, status: 400
        return
      end
      
      # Validate the date is not in the past
      if race_date < Date.current
        render json: { success: false, message: "First race date cannot be in the past" }, status: 400
        return
      end
      
      # Clear any existing first race dates for this year
      FirstRaceDate.where(season_year: current_year).destroy_all
      
      # Create new first race date
      first_race_date = FirstRaceDate.create!(
        race_date: race_date,
        season_year: current_year
      )
      
      render json: { 
        success: true, 
        message: "First race date set successfully to #{race_date.strftime('%B %d, %Y')}",
        first_race_date: {
          race_date: first_race_date.race_date,
          season_year: first_race_date.season_year
        }
      }
    rescue => e
      render json: { success: false, message: "Failed to set first race date: #{e.message}" }, status: 500
    end
  end
  
  def get_first_race_date
    require_login
    unless current_user.username == "SidathPeiris"
      render json: { success: false, message: "Access denied. Admin privileges required." }, status: 403
      return
    end
    
    begin
      current_year = Date.current.year
      first_race_date = FirstRaceDate.find_by(season_year: current_year)
      
      if first_race_date
        render json: { 
          success: true, 
          first_race_date: {
            race_date: first_race_date.race_date,
            season_year: first_race_date.season_year
          }
        }
      else
        render json: { success: true, first_race_date: nil }
      end
    rescue => e
      render json: { success: false, message: "Failed to get first race date: #{e.message}" }, status: 500
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

  def enter_race_results
    require_login
    unless current_user.username == "SidathPeiris"
      redirect_to dashboard_path, alert: "Access denied. Admin privileges required."
      return
    end
    
    @races = Race.order(:date)
    @drivers = Driver.all
    @constructors = Constructor.all
  end

  def submit_race_results
    require_login
    unless current_user.username == "SidathPeiris"
      redirect_to dashboard_path, alert: "Access denied. Admin privileges required."
      return
    end
    
    race_id = params[:race_id]
    race = Race.find(race_id)
    
    # Clear existing results for this race
    race.driver_results.destroy_all
    race.constructor_results.destroy_all
    race.qualifying_results.destroy_all
    
    # Create driver results (Top 10)
    if params[:driver_results]
      params[:driver_results].each do |position, result|
        next if result[:driver_id].blank?
        
        # Find the driver to get their name and team
        driver = Driver.find(result[:driver_id])
        
        DriverResult.create!(
          race: race,
          driver: driver.name,
          team: driver.team,
          position: position.to_i,
          points: result[:points].to_i
        )
      end
    end
    
    # Create constructor results (Top 3) - auto-populated from driver selections
    if params[:constructor_results]
      params[:constructor_results].each do |position, result|
        next if result[:constructor_name].blank?
        
        ConstructorResult.create!(
          race: race,
          constructor: result[:constructor_name],
          position: position.to_i,
          points: result[:points].to_i
        )
      end
    end
    
    # Create qualifying results (Top 3)
    if params[:qualifying_results]
      params[:qualifying_results].each do |position, result|
        next if result[:driver_id].blank?
        QualifyingResult.create!(
          race: race,
          driver_id: result[:driver_id],
          position: position.to_i,
          points: result[:points].to_i
        )
      end
    end
    
    redirect_to "/enter-race-results", notice: "Race results for #{race.name} have been saved successfully!"
  end

  def get_race_results
    require_login
    unless current_user.username == "SidathPeiris"
      render json: { success: false, message: "Access denied. Admin privileges required." }, status: 403
      return
    end
    
    race = Race.find(params[:id])
    
    results = {
      driver_results: race.driver_results.map do |dr|
        {
          position: dr.position,
          driver_id: Driver.find_by(name: dr.driver)&.id,
          driver_name: dr.driver,
          team: dr.team,
          points: dr.points
        }
      end,
      constructor_results: race.constructor_results.map do |cr|
        {
          position: cr.position,
          constructor: cr.constructor,
          points: cr.points
        }
      end,
      qualifying_results: race.qualifying_results.map do |qr|
        {
          position: qr.position,
          driver_id: qr.driver_id,
          points: qr.points
        }
      end
    }
    
    render json: { success: true, results: results }
  rescue => e
    render json: { success: false, message: "Error fetching race results: #{e.message}" }, status: 500
  end
end
