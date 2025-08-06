class Driver < ApplicationRecord
  has_many :driver_results, foreign_key: :driver, primary_key: :name
  
  validates :name, presence: true, uniqueness: true
  validates :team, presence: true
  validates :base_price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :current_rating, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 5.0 }
  
  scope :by_team, ->(team_name) { where(team: team_name) }
  scope :popular, -> { order(current_rating: :desc).limit(4) }
  
  def update_rating_and_price!
    recent_performance = DriverResult.average_performance_for_driver(name, 5)
    championship_position = self.championship_position
    championships_won = get_championships_won
    
    # Calculate new rating based on performance, championship position, and championship history
    performance_rating = [(recent_performance / 5.0), 5.0].min
    championship_rating = calculate_championship_rating(championship_position)
    championship_history_rating = calculate_championship_history_rating(championships_won)
    
    # Combine performance (60%), championship position (30%), and championship history (10%)
    new_rating = (performance_rating * 0.6 + championship_rating * 0.3 + championship_history_rating * 0.1).round(1)
    new_rating = [new_rating, 1.0].max # Minimum rating of 1.0
    
    # Calculate new price based on performance, rating, championship position, and championship history
    performance_multiplier = recent_performance / 10.0 # Normalize to 0-2.5 range
    rating_multiplier = new_rating / 2.5 # Normalize to 0-2 range
    championship_multiplier = calculate_championship_multiplier(championship_position)
    championship_history_multiplier = calculate_championship_history_multiplier(championships_won)
    
    new_price = (base_price * (1 + performance_multiplier + rating_multiplier + championship_multiplier + championship_history_multiplier)).round
    
    # Ensure price stays within reasonable bounds
    new_price = [new_price, 50].min # Max $50M
    new_price = [new_price, 15].max # Min $15M
    
    update!(
      current_rating: new_rating,
      current_price: new_price
    )
  end
  
  def current_price
    # Calculate dynamic price based on recent performance, championship position, and championship history
    recent_performance = DriverResult.average_performance_for_driver(name, 5)
    championship_position = self.championship_position
    championships_won = get_championships_won
    
    performance_multiplier = recent_performance / 10.0
    rating_multiplier = current_rating / 2.5
    championship_multiplier = calculate_championship_multiplier(championship_position)
    championship_history_multiplier = calculate_championship_history_multiplier(championships_won)
    
    price = (base_price * (1 + performance_multiplier + rating_multiplier + championship_multiplier + championship_history_multiplier)).round
    [price, 50].min # Cap at $50M
  end
  
  def self.update_all_ratings!
    all.each(&:update_rating_and_price!)
  end
  
  def recent_results(limit = 5)
    driver_results.joins(:race).order('races.date DESC').limit(limit)
  end
  
  def championship_position
    # Try to get position from actual race results
    position_from_results = Driver.joins(:driver_results)
                                 .group('drivers.name')
                                 .sum('driver_results.points')
                                 .sort_by { |_, points| -points }
                                 .find_index { |name, _| name == self.name }&.+ 1
    
    return position_from_results if position_from_results
    
    # Fallback to current 2025 standings from RacingNews365
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
end
