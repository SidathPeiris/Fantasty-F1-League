class DriverResult < ApplicationRecord
  belongs_to :race
  
  validates :driver, presence: true
  validates :team, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  scope :recent, -> { joins(:race).where('races.date >= ?', 30.days.ago) }
  scope :by_driver, ->(driver_name) { where(driver: driver_name) }
  scope :by_team, ->(team_name) { where(team: team_name) }
  
  def performance_score
    base_score = case position
                 when 1 then 25
                 when 2 then 18
                 when 3 then 15
                 when 4 then 12
                 when 5 then 10
                 when 6 then 8
                 when 7 then 6
                 when 8 then 4
                 when 9 then 2
                 when 10 then 1
                 else 0
                 end
    
    # Bonus for fastest lap
    base_score += 1 if fastest_lap
    
    # Penalty for DNF
    base_score = 0 if dnf
    
    base_score
  end
  
  def self.average_performance_for_driver(driver_name, races_count = 5)
    recent_results = by_driver(driver_name).joins(:race).order('races.date DESC').limit(races_count)
    return 0 if recent_results.empty?
    
    total_score = recent_results.sum(&:performance_score)
    (total_score.to_f / recent_results.count).round(1)
  end
end
