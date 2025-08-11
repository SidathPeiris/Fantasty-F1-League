class Driver < ApplicationRecord
  has_one_attached :photo
  has_many :driver_results, foreign_key: :driver, primary_key: :name
  
  validates :name, presence: true, uniqueness: true
  validates :team, presence: true
  validates :base_price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :current_rating, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 5.0 }
  
  scope :by_team, ->(team_name) { where(team: team_name) }
  scope :popular, -> { order(current_rating: :desc).limit(4) }
  
  def update_rating_and_price!
    recent_performance = DriverResult.average_performance_for_driver(name, 5)
    season_performance = DriverResult.average_performance_for_driver(name, 20) # Season-long performance
    championship_position = self.championship_position
    championships_won = get_championships_won
    
    # Calculate rating components
    championship_history_rating = calculate_championship_history_rating(championships_won)
    championship_position_rating = calculate_championship_rating(championship_position)
    recent_performance_rating = [(recent_performance / 5.0), 5.0].min
    season_performance_rating = [(season_performance / 5.0), 5.0].min
    
    # NEW BALANCED SYSTEM: 10% history + 50% position + 30% recent + 10% season
    new_rating = (
      championship_history_rating * 0.1 +      # 10% - Championship history
      championship_position_rating * 0.5 +     # 50% - Current championship position
      recent_performance_rating * 0.3 +        # 30% - Last 5 races performance
      season_performance_rating * 0.1          # 10% - Season-long performance
    ).round(1)
    
    new_rating = [new_rating, 1.0].max # Minimum rating of 1.0
    
    # NEW PRICING SYSTEM: Balanced for $100M budget
    # Base price based on championship position and rating
    base_price = calculate_base_price_from_position(championship_position)
    
    # Apply rating multiplier (0.8x to 1.2x based on rating)
    rating_multiplier = (new_rating / 5.0) * 0.4 + 0.8
    new_price = (base_price * rating_multiplier).round
    
    # Ensure price stays within reasonable bounds for $100M budget
    new_price = [new_price, 50].min # Max $50M
    new_price = [new_price, 15].max # Min $15M
    
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
    price = [price, 50].min # Max $50M
    price = [price, 15].max # Min $15M
    price
  end
  
  def self.update_all_ratings!
    all.each(&:update_rating_and_price!)
  end
  
  def recent_results(limit = 5)
    driver_results.joins(:race).order('races.date DESC').limit(limit)
  end
  
  def championship_position
    # Use stored championship position from database if available
    return self[:championship_position] if self[:championship_position].present?
    
    # Try to get position from actual race results
    position_from_results = Driver.joins(:driver_results)
                                 .group('drivers.name')
                                 .sum('driver_results.points')
                                 .sort_by { |_, points| -points }
                                 .find_index { |name, _| name == self.name }&.+ 1
    
    return position_from_results if position_from_results
    
    # Fallback to current 2025 standings from RacingNews365 (as of August 2025)
    current_standings = {
      "Oscar Piastri" => 1,
      "Lando Norris" => 2,
      "Max Verstappen" => 3,
      "George Russell" => 4,
      "Charles Leclerc" => 5,
      "Lewis Hamilton" => 6,
      "Kimi Antonelli" => 7,
      "Alexander Albon" => 8,
      "Nico Hulkenberg" => 9,
      "Esteban Ocon" => 10,
      "Fernando Alonso" => 11,
      "Lance Stroll" => 12,
      "Isack Hadjar" => 13,
      "Pierre Gasly" => 14,
      "Liam Lawson" => 15,
      "Yuki Tsunoda" => 16,
      "Oliver Bearman" => 17,
      "Gabriel Bortoleto" => 18,
      "Franco Colapinto" => 19,
      "Carlos Sainz" => 20
    }
    
    current_standings[name] || 20
  end
  
  private
  
  def get_championships_won
    championship_wins = {
      "Lewis Hamilton" => 7,
      "Max Verstappen" => 4,  # 2021, 2022, 2023, 2024 championships
      "Fernando Alonso" => 2,
      "Charles Leclerc" => 0,
      "Lando Norris" => 0,
      "Oscar Piastri" => 0,
      "George Russell" => 0,
      "Carlos Sainz" => 0,
      "Lance Stroll" => 0,
      "Alexander Albon" => 0,
      "Yuki Tsunoda" => 0,
      "Nico Hulkenberg" => 0,
      "Liam Lawson" => 0,
      "Esteban Ocon" => 0,
      "Pierre Gasly" => 0,
      "Kimi Antonelli" => 0,
      "Gabriel Bortoleto" => 0,
      "Isack Hadjar" => 0,
      "Oliver Bearman" => 0,
      "Franco Colapinto" => 0
    }
    championship_wins[name] || 0
  end
  
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
    when 11..15 then 3.0
    when 16..20 then 2.5
    else 2.0
    end
  end
  
  def calculate_championship_history_rating(championships)
    return 5.0 if championships >= 7  # Lewis Hamilton level
    return 4.8 if championships >= 5  # Multiple championships
    return 4.5 if championships >= 3  # Few championships
    return 4.0 if championships >= 1  # Single championship
    return 0.0  # No championships
  end
  
  def calculate_championship_multiplier(position)
    return 0.0 if position.nil? || position == 0
    
    case position
    when 1 then 0.5
    when 2 then 0.4
    when 3 then 0.3
    when 4 then 0.2
    when 5 then 0.1
    when 6..10 then 0.0
    when 11..15 then -0.1
    when 16..20 then -0.2
    else -0.3
    end
  end
  
  def calculate_championship_history_multiplier(championships)
    return 0.3 if championships >= 7  # Lewis Hamilton: +30% price boost
    return 0.2 if championships >= 5  # Multiple championships: +20% price boost
    return 0.15 if championships >= 3 # Few championships: +15% price boost
    return 0.1 if championships >= 1  # Single championship: +10% price boost
    return 0.0  # No championships: no boost
  end

  private
  
  def calculate_base_price_from_position(position)
    return 50 if position.nil? || position == 0
    
    case position
    when 1..2 then 50    # Top 2 drivers: $50M
    when 3..4 then 40    # 3rd-4th: $40M
    when 5..6 then 35    # 5th-6th: $35M
    when 7..8 then 30    # 7th-8th: $30M
    when 9..10 then 25   # 9th-10th: $25M
    when 11..15 then 20  # 11th-15th: $20M
    when 16..20 then 15  # 16th-20th: $15M
    else 15
    end
  end
end
