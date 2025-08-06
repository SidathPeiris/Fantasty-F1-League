class Constructor < ApplicationRecord
  has_many :constructor_results, foreign_key: :constructor, primary_key: :name
  
  validates :name, presence: true, uniqueness: true
  validates :base_price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :current_rating, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 5.0 }
  
  scope :popular, -> { order(current_rating: :desc).limit(3) }
  
  def update_rating_and_price!
    recent_performance = ConstructorResult.average_performance_for_constructor(name, 5)
    championship_position = self.championship_position
    
    # Calculate new rating based on performance and championship position
    performance_rating = [(recent_performance / 5.0), 5.0].min
    championship_rating = calculate_championship_rating(championship_position)
    
    # Combine performance (70%) and championship position (30%)
    new_rating = (performance_rating * 0.7 + championship_rating * 0.3).round(1)
    new_rating = [new_rating, 1.0].max # Minimum rating of 1.0
    
    # Calculate new price based on performance, rating, and championship position
    # Multipliers adjusted to be less aggressive
    performance_multiplier = recent_performance / 20.0 # Normalize to 0-1.25 range
    rating_multiplier = new_rating / 5.0 # Normalize to 0-1 range
    championship_multiplier = calculate_championship_multiplier(championship_position) / 2
    
    new_price = (base_price * (1 + performance_multiplier + rating_multiplier + championship_multiplier)).round
    
    # Ensure price stays within reasonable bounds
    new_price = [new_price, 30].min # Max $30M
    new_price = [new_price, 5].max # Min $5M
    
    update!(
      current_rating: new_rating,
      current_price: new_price
    )
  end
  
  def current_price
    # Calculate dynamic price based on recent performance and championship position
    recent_performance = ConstructorResult.average_performance_for_constructor(name, 5)
    championship_position = self.championship_position
    
    # Multipliers adjusted to be less aggressive
    performance_multiplier = recent_performance / 20.0
    rating_multiplier = current_rating / 5.0
    championship_multiplier = calculate_championship_multiplier(championship_position) / 2
    
    price = (base_price * (1 + performance_multiplier + rating_multiplier + championship_multiplier)).round
    [price, 30].min # Cap at $30M
  end
  
  def self.update_all_ratings!
    all.each(&:update_rating_and_price!)
  end
  
  def recent_results(limit = 5)
    constructor_results.joins(:race).order('races.date DESC').limit(limit)
  end
  
  def championship_position
    # Try to get position from actual race results
    position_from_results = Constructor.joins(:constructor_results)
                                     .group('constructors.name')
                                     .sum('constructor_results.points')
                                     .sort_by { |_, points| -points }
                                     .find_index { |name, _| name == self.name }&.+ 1
    
    return position_from_results if position_from_results
    
    # Fallback to current 2025 standings from RacingNews365
    current_standings = {
      "McLaren" => 1,
      "Ferrari" => 2,
      "Mercedes" => 3,
      "Red Bull Racing" => 4,
      "Williams" => 5,
      "Aston Martin" => 6,
      "Stake F1 Team" => 7,
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
  
  def calculate_championship_multiplier(position)
    return 0.0 if position.nil? || position == 0
    
    case position
    when 1 then 0.5
    when 2 then 0.4
    when 3 then 0.3
    when 4 then 0.2
    when 5 then 0.1
    when 6..8 then 0.0
    when 9..10 then -0.1
    else -0.2
    end
  end
end
