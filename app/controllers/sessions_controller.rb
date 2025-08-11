class SessionsController < ApplicationController
  def create
    email_or_username = params[:login][:email_or_username]
    password = params[:login][:password]
    
    # Try to find user by email or username
    user = User.find_by(email: email_or_username) || User.find_by(username: email_or_username)
    
    if user && user.authenticate(password)
      # Store user id in session
      session[:user_id] = user.id
      Rails.logger.info "User #{user.full_name} logged in successfully"
      redirect_to dashboard_path, notice: "Welcome to Fantasy F1 League! 🏎️"
    else
      Rails.logger.error "Login failed for #{email_or_username}"
      redirect_to login_path, alert: "Invalid email/username or password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You have been logged out successfully. See you next time! 🏎️"
  end
end
