class QualifyingResult < ApplicationRecord
  belongs_to :race
  belongs_to :driver
  
  validates :position, presence: true, numericality: { greater_than: 0 }
  validates :points, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  scope :top_three, -> { where(position: [1, 2, 3]).order(:position) }
end
