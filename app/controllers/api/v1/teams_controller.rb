class Api::V1::TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: [:show, :update, :destroy]
  
  def index
    @teams = current_user.teams.order(created_at: :desc)
    render json: @teams.map(&:to_json_data)
  end
  
  def show
    render json: @team.to_json_data
  end
  
  def create
    # Check if user already has an active team
    if current_user.has_active_team?
      render json: { error: 'You already have an active team. Please submit or archive it first.' }, status: :unprocessable_entity
      return
    end
    
    @team = current_user.create_team(team_params[:name])
    
    if @team.persisted?
      # Add drivers
      team_params[:drivers].each do |driver_id|
        driver = Driver.find(driver_id)
        @team.team_selections.create!(
          selectable: driver,
          cost: driver.current_price
        )
      end
      
      # Add constructor
      constructor = Constructor.find(team_params[:constructor_id])
      @team.team_selections.create!(
        selectable: constructor,
        cost: constructor.current_price
      )
      
      @team.update_total_cost
      
      render json: @team.to_json_data, status: :created
    else
      render json: { error: @team.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end
  
  def update
    if @team.update(team_params)
      render json: @team.to_json_data
    else
      render json: { error: @team.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @team.destroy
    head :no_content
  end
  
  def submit
    @team = current_user.teams.active.first
    
    unless @team
      render json: { error: 'No active team found' }, status: :not_found
      return
    end
    
    unless @team.can_submit?
      render json: { error: 'Team cannot be submitted. Please ensure you have exactly 2 drivers and 1 constructor within budget.' }, status: :unprocessable_entity
      return
    end
    
    @team.update(status: 'submitted')
    render json: @team.to_json_data
  end
  
  private
  
  def set_team
    @team = current_user.teams.find(params[:id])
  end
  
  def team_params
    params.require(:team).permit(:name, drivers: [], constructor_id: [])
  end
end

