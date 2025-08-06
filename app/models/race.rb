class Race < ApplicationRecord
  has_many :driver_results, dependent: :destroy
  has_many :constructor_results, dependent: :destroy
  
  validates :name, presence: true
  validates :date, presence: true
  validates :circuit, presence: true
  validates :country, presence: true
  
  scope :recent, -> { order(date: :desc).limit(5) }
  scope :this_season, -> { where('date >= ?', Date.new(2025, 1, 1)) }
  
  def self.latest_race
    order(date: :desc).first
  end
  
  def driver_standings_after_race
    driver_results.joins(:driver)
                  .group('drivers.name')
                  .sum(:points)
                  .sort_by { |_, points| -points }
  end
  
  def constructor_standings_after_race
    constructor_results.group(:constructor)
                      .sum(:points)
                      .sort_by { |_, points| -points }
  end
end
