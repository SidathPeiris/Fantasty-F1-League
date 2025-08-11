class TeamSelection < ApplicationRecord
  belongs_to :team
  belongs_to :selectable, polymorphic: true
  
  validates :cost, presence: true, numericality: { greater_than: 0 }
  validates :selectable_id, uniqueness: { scope: [:team_id, :selectable_type] }
  
  after_save :update_team_cost
  after_destroy :update_team_cost
  
  private
  
  def update_team_cost
    team.update_total_cost
  end
end

