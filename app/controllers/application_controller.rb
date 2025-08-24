class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :get_team_color
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    # If user doesn't exist, clear the session
    session[:user_id] = nil
    nil
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless session[:user_id]
      redirect_to login_path, alert: "Please log in to access this page."
      return false
    end
    true
  end
  
  def authenticate_user!
    unless logged_in?
      render json: { error: 'Authentication required' }, status: :unauthorized
      return
    end
  end

  def get_team_color(team_name)
    return '#9CA3AF' unless team_name # Default gray for nil
    
    # Try to find the constructor by name and get its team color
    constructor = Constructor.find_by(name: team_name)
    if constructor&.team_color
      constructor.team_color
    else
      # Fallback to hardcoded values for any teams not in database
      case team_name&.downcase
      when 'mercedes'
        '#00D7B6' # Mercedes teal
      when 'red bull racing', 'red bull'
        '#4781D7' # Red Bull Racing blue
      when 'ferrari'
        '#ED1131' # Ferrari red
      when 'mclaren'
        '#F47600' # McLaren orange
      when 'alpine'
        '#00A1E8' # Alpine blue
      when 'racing bulls', 'rb'
        '#6C98FF' # Racing Bulls blue
      when 'aston martin'
        '#229971' # Aston Martin green
      when 'williams'
        '#1868DB' # Williams blue
      when 'kick sauber', 'sauber'
        '#01C00E' # Kick Sauber green
      when 'haas f1 team', 'haas'
        '#9CA3AF' # Haas gray
      else
        '#9CA3AF' # Default gray
      end
    end
  end
  
  def mid_season_break_active?
    break_period = MidSeasonBreak.first
    return false unless break_period
    
    current_date = Date.current
    current_date >= break_period.start_date && current_date <= break_period.end_date
  end
  
  def can_edit_team?
    current_date = Date.current
    current_year = current_date.year
    
    # Check if we're in the pre-season period (Jan 1st to first race)
    first_race = FirstRaceDate.find_by(season_year: current_year)
    if first_race && current_date < first_race.race_date
      return true # Pre-season: can edit freely
    end
    
    # Check if we're in mid-season break
    if mid_season_break_active?
      return true # Mid-season break: can edit
    end
    
    # Race season: teams are locked
    false
  end
  
  def can_create_team?
    # Users can always create a team, regardless of dates
    true
  end
  
  def team_edit_status
    current_date = Date.current
    current_year = current_date.year
    
    if can_edit_team?
      first_race = FirstRaceDate.find_by(season_year: current_year)
      if first_race && current_date < first_race.race_date
        return {
          can_edit: true,
          status: "pre_season",
          message: "Pre-season: Teams can be edited freely until first race",
          next_lock: first_race.race_date
        }
      elsif mid_season_break_active?
        break_period = MidSeasonBreak.first
        return {
          can_edit: true,
          status: "mid_season_break",
          message: "Mid-season break: Teams can be edited",
          next_lock: break_period.end_date
        }
      end
    else
      first_race = FirstRaceDate.find_by(season_year: current_year)
      if first_race && current_date >= first_race.race_date
        return {
          can_edit: false,
          status: "race_season",
          message: "Race season: Teams are locked until mid-season break",
          next_unlock: "mid_season_break"
        }
      else
        return {
          can_edit: false,
          status: "unknown",
          message: "Team editing is currently disabled",
          next_unlock: "unknown"
        }
      end
    end
  end
  
  helper_method :mid_season_break_active?, :can_edit_team?, :can_create_team?, :team_edit_status
end
