class SprintResult < ApplicationRecord
  belongs_to :race
  belongs_to :driver
  
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 8 }
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :race_id, presence: true
  validates :driver_id, presence: true
  
  # Ensure unique position per race
  validates :position, uniqueness: { scope: :race_id }
  validates :driver_id, uniqueness: { scope: :race_id }
end
