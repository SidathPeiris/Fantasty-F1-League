class PointsService
  # F1 Race Points (2024-2025 system)
  RACE_POINTS = {
    1 => 25, 2 => 18, 3 => 15, 4 => 12, 5 => 10,
    6 => 8, 7 => 6, 8 => 4, 9 => 2, 10 => 1
  }.freeze

  # Constructor Points (no multiplier)
  CONSTRUCTOR_POINTS = {
    1 => 10, 2 => 5, 3 => 2
  }.freeze

  # Qualifying Bonus Points (no multiplier)
  QUALIFYING_POINTS = {
    1 => 3, 2 => 2, 3 => 1
  }.freeze

  # Sprint Race Points (2024-2025 system)
  SPRINT_RACE_POINTS = {
    1 => 8, 2 => 7, 3 => 6, 4 => 5, 5 => 4, 6 => 3, 7 => 2, 8 => 1
  }.freeze

  # Sprint Qualifying Points (no multiplier)
  SPRINT_QUALIFYING_POINTS = {
    1 => 3, 2 => 2, 3 => 1
  }.freeze

  # Constructor Sprint Points (no multiplier)
  CONSTRUCTOR_SPRINT_POINTS = {
    1 => 3, 2 => 2, 3 => 1
  }.freeze

  # Driver Position Multipliers (Main Race)
  DRIVER_MULTIPLIERS = {
    [1, 2] => 2.0,    # 1st + 2nd = 2x
    [1, 3] => 1.5,    # 1st + 3rd = 1.5x
    [2, 3] => 1.2     # 2nd + 3rd = 1.2x
  }.freeze

  # Sprint Race Team Driver Multipliers (similar to main race)
  SPRINT_DRIVER_MULTIPLIERS = {
    [1, 2] => 1.5,    # 1st + 2nd = 1.5x
    [1, 3] => 1.3,    # 1st + 3rd = 1.3x
    [2, 3] => 1.1     # 2nd + 3rd = 1.1x
  }.freeze

  def self.calculate_race_points(position)
    RACE_POINTS[position] || 0
  end

  def self.calculate_constructor_points(position)
    CONSTRUCTOR_POINTS[position] || 0
  end

  def self.calculate_qualifying_points(position)
    QUALIFYING_POINTS[position] || 0
  end

  def self.calculate_sprint_race_points(position)
    SPRINT_RACE_POINTS[position] || 0
  end

  def self.calculate_sprint_qualifying_points(position)
    SPRINT_QUALIFYING_POINTS[position] || 0
  end

  def self.calculate_constructor_sprint_points(position)
    CONSTRUCTOR_SPRINT_POINTS[position] || 0
  end

  def self.calculate_sprint_driver_multiplier(driver_positions)
    return 1.0 if driver_positions.empty? || driver_positions.length < 2

    # Sort positions to check for multiplier combinations
    sorted_positions = driver_positions.sort
    
    # Check for exact matches first
    SPRINT_DRIVER_MULTIPLIERS.each do |positions, multiplier|
      if sorted_positions == positions
        return multiplier
      end
    end

    # Check if positions contain the multiplier combinations
    SPRINT_DRIVER_MULTIPLIERS.each do |positions, multiplier|
      if positions.all? { |pos| sorted_positions.include?(pos) }
        return multiplier
      end
    end

    1.0 # No multiplier if no match found
  end

  def self.calculate_driver_multiplier(driver_positions)
    return 1.0 if driver_positions.empty? || driver_positions.length < 2

    # Sort positions to check for multiplier combinations
    sorted_positions = driver_positions.sort
    
    # Check for exact matches first
    DRIVER_MULTIPLIERS.each do |positions, multiplier|
      if sorted_positions == positions
        return multiplier
      end
    end

    # Check if positions contain the multiplier combinations
    DRIVER_MULTIPLIERS.each do |positions, multiplier|
      if positions.all? { |pos| sorted_positions.include?(pos) }
        return multiplier
      end
    end

    1.0 # No multiplier if no match found
  end

  def self.calculate_team_score(team_selection, race_results, qualifying_results = nil, sprint_results = nil, sprint_qualifying_results = nil, constructor_sprint_results = nil)
    return 0 unless team_selection && race_results

    # Get driver positions from race results
    driver_positions = []
    team_selection.drivers.each do |driver|
      driver_result = race_results.find { |r| r.driver == driver.name }
      if driver_result
        driver_positions << driver_result.position
      end
    end

    # Get constructor position from race results
    constructor_position = nil
    if team_selection.constructor
      constructor_result = race_results.find { |r| r.constructor == team_selection.constructor.name }
      if constructor_result
        constructor_position = constructor_result.position
      end
    end

    # Calculate base driver points
    base_driver_points = driver_positions.sum { |pos| calculate_race_points(pos) }
    
    # Apply multiplier
    multiplier = calculate_driver_multiplier(driver_positions)
    multiplied_driver_points = base_driver_points * multiplier

    # Add constructor points (no multiplier)
    constructor_points = calculate_constructor_points(constructor_position) || 0

    # Add qualifying bonus points (no multiplier)
    qualifying_bonus = 0
    if qualifying_results
      team_selection.drivers.each do |driver|
        qualifying_result = qualifying_results.find { |q| q.driver == driver.name }
        if qualifying_result
          qualifying_bonus += calculate_qualifying_points(qualifying_result.position)
        end
      end
    end

    # Calculate sprint race points with team-based multipliers
    sprint_race_points = 0
    if sprint_results
      # Get sprint positions for team drivers
      sprint_driver_positions = []
      team_selection.drivers.each do |driver|
        sprint_result = sprint_results.find { |s| s.driver_id == driver.id }
        if sprint_result
          sprint_driver_positions << sprint_result.position
        end
      end
      
      # Calculate base sprint points
      base_sprint_points = sprint_driver_positions.sum { |pos| calculate_sprint_race_points(pos) }
      
      # Apply team-based multiplier
      sprint_multiplier = calculate_sprint_driver_multiplier(sprint_driver_positions)
      sprint_race_points = base_sprint_points * sprint_multiplier
    end

    # Add sprint qualifying points (no multiplier)
    sprint_qualifying_bonus = 0
    if sprint_qualifying_results
      team_selection.drivers.each do |driver|
        sprint_qualifying_result = sprint_qualifying_results.find { |sq| sq.driver_id == driver.id }
        if sprint_qualifying_result
          sprint_qualifying_bonus += calculate_sprint_qualifying_points(sprint_qualifying_result.position)
        end
      end
    end

    # Add constructor sprint points (no multiplier)
    constructor_sprint_points = 0
    if constructor_sprint_results && team_selection.constructor
      constructor_sprint_result = constructor_sprint_results.find { |cs| cs.constructor_name == team_selection.constructor.name }
      if constructor_sprint_result
        constructor_sprint_points = calculate_constructor_sprint_points(constructor_sprint_result.position)
      end
    end

    # Total score
    total_score = multiplied_driver_points + constructor_points + qualifying_bonus + sprint_race_points + sprint_qualifying_bonus + constructor_sprint_points
    
    {
      base_driver_points: base_driver_points,
      multiplier: multiplier,
      multiplied_driver_points: multiplied_driver_points,
      constructor_points: constructor_points,
      qualifying_bonus: qualifying_bonus,
      sprint_race_points: sprint_race_points,
      sprint_qualifying_bonus: sprint_qualifying_bonus,
      constructor_sprint_points: constructor_sprint_points,
      total_score: total_score
    }
  end

  def self.calculate_race_points_for_driver(driver_name, race_results)
    driver_result = race_results.find { |r| r.driver == driver_name }
    return 0 unless driver_result
    
    calculate_race_points(driver_result.position)
  end

  def self.calculate_race_points_for_constructor(constructor_name, race_results)
    constructor_result = race_results.find { |r| r.constructor == constructor_name }
    return 0 unless constructor_result
    
    calculate_constructor_points(constructor_result.position)
  end

  def self.calculate_qualifying_points_for_driver(driver_id, qualifying_results)
    qualifying_result = qualifying_results.find { |q| q.driver_id == driver_id }
    return 0 unless qualifying_result
    
    calculate_qualifying_points(qualifying_result.position)
  end

  def self.calculate_sprint_race_points_for_driver(driver_id, sprint_results)
    sprint_result = sprint_results.find { |s| s.driver_id == driver_id }
    return 0 unless sprint_result
    
    calculate_sprint_race_points(sprint_result.position)
  end

  def self.calculate_sprint_qualifying_points_for_driver(driver_id, sprint_qualifying_results)
    sprint_qualifying_result = sprint_qualifying_results.find { |sq| sq.driver_id == driver_id }
    return 0 unless sprint_qualifying_result
    
    calculate_sprint_qualifying_points(sprint_qualifying_result.position)
  end

  def self.calculate_constructor_sprint_points_for_constructor(constructor_name, constructor_sprint_results)
    constructor_sprint_result = constructor_sprint_results.find { |cs| cs.constructor_name == constructor_name }
    return 0 unless constructor_sprint_result
    
    calculate_constructor_sprint_points(constructor_sprint_result.position)
  end
end
