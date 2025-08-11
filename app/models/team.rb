class Team < ApplicationRecord
  belongs_to :user
  has_many :team_selections, dependent: :destroy
  has_many :drivers, through: :team_selections, source: :selectable, source_type: 'Driver'
  has_many :constructors, through: :team_selections, source: :selectable, source_type: 'Constructor'
  
  validates :name, presence: true
  validates :status, inclusion: { in: %w[active archived submitted] }
  
  scope :active, -> { where(status: 'active') }
  scope :submitted, -> { where(status: 'submitted') }
  
  def can_submit?
    drivers.count == 2 && constructors.count == 1 && total_cost <= 100
  end
  
  def update_total_cost
    update(total_cost: team_selections.sum(:cost))
  end
  
  def driver_selections
    team_selections.where(selectable_type: 'Driver')
  end
  
  def constructor_selections
    team_selections.where(selectable_type: 'Constructor')
  end
  
  def to_json_data
    {
      id: id,
      name: name,
      total_cost: total_cost,
      status: status,
      drivers: drivers.map do |driver|
        selection = driver_selections.find_by(selectable: driver)
        {
          id: driver.id,
          name: driver.name,
          team: driver.team,
          rating: driver.current_rating,
          cost: selection.cost
        }
      end,
      constructor: constructors.first ? {
        id: constructors.first.id,
        name: constructors.first.name,
        rating: constructors.first.current_rating,
        cost: constructor_selections.first.cost
      } : nil,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end

