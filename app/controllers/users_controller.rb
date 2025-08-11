class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    
    if @user.save
      # Log the user in after successful signup
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: "Welcome to Fantasy F1 League, #{@user.full_name}! 🏎️ Your account has been created successfully!"
    else
      # If validation fails, redirect back to signup page
      redirect_to signup_path, alert: @user.errors.full_messages.join(', ')
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :username, :password, :password_confirmation)
  end
end
