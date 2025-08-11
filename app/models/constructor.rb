class Constructor < ApplicationRecord
  has_one_attached :logo
  has_many :constructor_results, foreign_key: :constructor, primary_key: :name
  
  validates :name, presence: true, uniqueness: true
  validates :base_price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :current_rating, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 5.0 }
  
  scope :popular, -> { order(current_rating: :desc).limit(3) }
  
  def update_rating_and_price!
    recent_performance = ConstructorResult.average_performance_for_constructor(name, 5)
    season_performance = ConstructorResult.average_performance_for_constructor(name, 20) # Season-long performance
    championship_position = self.championship_position
    
    # Calculate rating components
    championship_position_rating = calculate_championship_rating(championship_position)
    recent_performance_rating = [(recent_performance / 5.0), 5.0].min
    season_performance_rating = [(season_performance / 5.0), 5.0].min
    
    # NEW BALANCED SYSTEM: 50% position + 30% recent + 20% season (no history for constructors)
    new_rating = (
      championship_position_rating * 0.5 +     # 50% - Current championship position
      recent_performance_rating * 0.3 +        # 30% - Last 5 races performance
      season_performance_rating * 0.2          # 20% - Season-long performance
    ).round(1)
    
    new_rating = [new_rating, 1.0].max # Minimum rating of 1.0
    
    # NEW PRICING SYSTEM: Balanced for $100M budget
    # Base price based on championship position and rating
    base_price = calculate_base_price_from_position(championship_position)
    
    # Apply rating multiplier (0.8x to 1.2x based on rating)
    rating_multiplier = (new_rating / 5.0) * 0.4 + 0.8
    new_price = (base_price * rating_multiplier).round
    
    # Ensure price stays within reasonable bounds for $100M budget
    new_price = [new_price, 25].min # Max $25M
    new_price = [new_price, 5].max # Min $5M
    
    update!(
      current_rating: new_rating,
      current_price: new_price
    )
  end
  
  def current_price
    # Calculate dynamic price based on championship position and rating
    championship_position = self.championship_position
    
    # Base price based on championship position
    base_price = calculate_base_price_from_position(championship_position)
    
    # Apply rating multiplier
    rating_multiplier = (current_rating / 5.0) * 0.4 + 0.8
    price = (base_price * rating_multiplier).round
    
    # Ensure price stays within reasonable bounds
    price = [price, 25].min # Max $25M
    price = [price, 5].max # Min $5M
    price
  end
  
  def self.update_all_ratings!
    all.each(&:update_rating_and_price!)
  end
  
  def recent_results(limit = 5)
    constructor_results.joins(:race).order('races.date DESC').limit(limit)
  end
  
  def championship_position
    # Use stored championship position from database if available
    return self[:championship_position] if self[:championship_position].present?
    
    # Try to get position from actual race results
    position_from_results = Constructor.joins(:constructor_results)
                                     .group('constructors.name')
                                     .sum('constructor_results.points')
                                     .sort_by { |_, points| -points }
                                     .find_index { |name, _| name == self.name }&.+ 1
    
    return position_from_results if position_from_results
    
    # Fallback to current 2025 standings from RacingNews365 (as of August 2025)
    current_standings = {
      "McLaren" => 1,
      "Ferrari" => 2,
      "Mercedes" => 3,
      "Red Bull Racing" => 4,
      "Williams" => 5,
      "Aston Martin" => 6,
      "Kick Sauber" => 7,
      "Haas" => 8,
      "Racing Bulls" => 9,
      "Alpine" => 10
    }
    
    current_standings[name] || 10
  end
  
  private
  
  def calculate_championship_rating(position)
    return 5.0 if position.nil? || position == 0
    
    case position
    when 1 then 5.0
    when 2 then 4.8
    when 3 then 4.6
    when 4 then 4.4
    when 5 then 4.2
    when 6 then 4.0
    when 7 then 3.8
    when 8 then 3.6
    when 9 then 3.4
    when 10 then 3.2
    else 2.5
    end
  end
  
  def calculate_base_price_from_position(position)
    return 25 if position.nil? || position == 0
    
    case position
    when 1 then 25    # Top constructor: $25M
    when 2..3 then 20 # 2nd-3rd: $20M
    when 4..5 then 15 # 4th-5th: $15M
    when 6..7 then 12 # 6th-7th: $12M
    when 8..10 then 8 # 8th-10th: $8M
    else 5
    end
  end
end
