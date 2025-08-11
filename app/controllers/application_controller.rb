class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    # If user doesn't exist, clear the session
    session[:user_id] = nil
    nil
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      redirect_to root_path, notice: "Please log in to access this page."
    end
  end
  
  def authenticate_user!
    unless logged_in?
      render json: { error: 'Authentication required' }, status: :unauthorized
      return
    end
  end
end
