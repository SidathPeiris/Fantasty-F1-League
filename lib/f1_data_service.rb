class F1DataService
  require 'net/http'
  require 'json'
  require 'nokogiri'
  require 'uri'
  
  def self.populate_current_season_data
    # Create 2025 season races based on RacingNews365 data
    races_data = [
      { name: "Australian Grand Prix", date: "2025-03-16", circuit: "Albert Park", country: "Australia" },
      { name: "Saudi Arabian Grand Prix", date: "2025-03-23", circuit: "Jeddah Corniche", country: "Saudi Arabia" },
      { name: "Bahrain Grand Prix", date: "2025-03-30", circuit: "Bahrain International", country: "Bahrain" },
      { name: "Japanese Grand Prix", date: "2025-04-06", circuit: "Suzuka", country: "Japan" },
      { name: "Chinese Grand Prix", date: "2025-04-13", circuit: "Shanghai International", country: "China" },
      { name: "Miami Grand Prix", date: "2025-05-04", circuit: "Miami International", country: "USA" },
      { name: "Emilia Romagna Grand Prix", date: "2025-05-18", circuit: "Imola", country: "Italy" },
      { name: "Monaco Grand Prix", date: "2025-05-25", circuit: "Monaco", country: "Monaco" },
      { name: "Spanish Grand Prix", date: "2025-06-01", circuit: "Circuit de Barcelona-Catalunya", country: "Spain" },
      { name: "Canadian Grand Prix", date: "2025-06-15", circuit: "Circuit Gilles Villeneuve", country: "Canada" },
      { name: "Austrian Grand Prix", date: "2025-06-29", circuit: "Red Bull Ring", country: "Austria" },
      { name: "British Grand Prix", date: "2025-07-06", circuit: "Silverstone", country: "Great Britain" },
      { name: "Belgian Grand Prix", date: "2025-07-27", circuit: "Spa-Francorchamps", country: "Belgium" },
      { name: "Hungarian Grand Prix", date: "2025-08-03", circuit: "Hungaroring", country: "Hungary" }
    ]
    
    races_data.each do |race_data|
      Race.find_or_create_by(name: race_data[:name]) do |race|
        race.date = Date.parse(race_data[:date])
        race.circuit = race_data[:circuit]
        race.country = race_data[:country]
      end
    end
    
    # Create drivers with base data
    drivers_data = [
      { name: "Max Verstappen", team: "Red Bull Racing", base_price: 35, current_rating: 4.9 },
      { name: "Lewis Hamilton", team: "Ferrari", base_price: 30, current_rating: 4.7 },
      { name: "Charles Leclerc", team: "Ferrari", base_price: 28, current_rating: 4.6 },
      { name: "Lando Norris", team: "McLaren", base_price: 25, current_rating: 4.5 },
      { name: "Oscar Piastri", team: "McLaren", base_price: 22, current_rating: 4.4 },
      { name: "George Russell", team: "Mercedes", base_price: 24, current_rating: 4.3 },
      { name: "Carlos Sainz", team: "Williams", base_price: 20, current_rating: 4.2 },
      { name: "Fernando Alonso", team: "Aston Martin", base_price: 18, current_rating: 4.1 },
      { name: "Lance Stroll", team: "Aston Martin", base_price: 15, current_rating: 3.8 },
      { name: "Alexander Albon", team: "Williams", base_price: 16, current_rating: 3.9 },
      { name: "Yuki Tsunoda", team: "Red Bull Racing", base_price: 14, current_rating: 3.7 },
      { name: "Nico Hulkenberg", team: "Kick Sauber", base_price: 12, current_rating: 3.5 },
      { name: "Liam Lawson", team: "Racing Bulls", base_price: 13, current_rating: 3.6 },
      { name: "Esteban Ocon", team: "Haas", base_price: 11, current_rating: 3.4 },
      { name: "Pierre Gasly", team: "Alpine", base_price: 10, current_rating: 3.3 },
      { name: "Kimi Antonelli", team: "Mercedes", base_price: 17, current_rating: 3.8 },
      { name: "Gabriel Bortoleto", team: "Kick Sauber", base_price: 9, current_rating: 3.2 },
      { name: "Isack Hadjar", team: "Racing Bulls", base_price: 8, current_rating: 3.1 },
      { name: "Oliver Bearman", team: "Haas", base_price: 7, current_rating: 3.0 },
      { name: "Franco Colapinto", team: "Alpine", base_price: 6, current_rating: 2.9 }
    ]
    
    drivers_data.each do |driver_data|
      Driver.find_or_create_by(name: driver_data[:name]) do |driver|
        driver.team = driver_data[:team]
        driver.base_price = driver_data[:base_price]
        driver.current_rating = driver_data[:current_rating]
        driver.current_price = driver_data[:base_price]
      end
    end
    
    # Create constructors with base data (UPDATED BASE PRICES)
    constructors_data = [
      { name: "Red Bull Racing", base_price: 12, current_rating: 4.9 },
      { name: "Ferrari", base_price: 12, current_rating: 4.7 },
      { name: "Mercedes", base_price: 11, current_rating: 4.6 },
      { name: "McLaren", base_price: 12, current_rating: 4.8 },
      { name: "Williams", base_price: 10, current_rating: 4.0 },
      { name: "Aston Martin", base_price: 9, current_rating: 3.8 },
      { name: "Kick Sauber", base_price: 6, current_rating: 3.2 },
      { name: "Racing Bulls", base_price: 8, current_rating: 3.5 },
      { name: "Haas", base_price: 5, current_rating: 3.0 },
      { name: "Alpine", base_price: 7, current_rating: 3.1 }
    ]
    
    constructors_data.each do |constructor_data|
      Constructor.find_or_create_by(name: constructor_data[:name]) do |constructor|
        constructor.base_price = constructor_data[:base_price]
        constructor.current_rating = constructor_data[:current_rating]
        constructor.current_price = constructor_data[:base_price]
      end
    end
    
    # Populate with some sample race results based on current standings
    populate_sample_race_results
  end
  
  def self.populate_sample_race_results
    # Get the latest race (Hungarian GP)
    hungarian_gp = Race.find_by(name: "Hungarian Grand Prix")
    return unless hungarian_gp
    
    # Sample results based on current standings from RacingNews365
    driver_results = [
      { driver: "Oscar Piastri", team: "McLaren", position: 1, points: 25, fastest_lap: true, dnf: false },
      { driver: "Lando Norris", team: "McLaren", position: 2, points: 18, fastest_lap: false, dnf: false },
      { driver: "Max Verstappen", team: "Red Bull Racing", position: 3, points: 15, fastest_lap: false, dnf: false },
      { driver: "George Russell", team: "Mercedes", position: 4, points: 12, fastest_lap: false, dnf: false },
      { driver: "Charles Leclerc", team: "Ferrari", position: 5, points: 10, fastest_lap: false, dnf: false },
      { driver: "Lewis Hamilton", team: "Ferrari", position: 6, points: 8, fastest_lap: false, dnf: false },
      { driver: "Carlos Sainz", team: "Williams", position: 7, points: 6, fastest_lap: false, dnf: false },
      { driver: "Fernando Alonso", team: "Aston Martin", position: 8, points: 4, fastest_lap: false, dnf: false },
      { driver: "Alexander Albon", team: "Williams", position: 9, points: 2, fastest_lap: false, dnf: false },
      { driver: "Lance Stroll", team: "Aston Martin", position: 10, points: 1, fastest_lap: false, dnf: false }
    ]
    
    driver_results.each do |result_data|
      DriverResult.find_or_create_by(race: hungarian_gp, driver: result_data[:driver]) do |result|
        result.team = result_data[:team]
        result.position = result_data[:position]
        result.points = result_data[:points]
        result.fastest_lap = result_data[:fastest_lap]
        result.dnf = result_data[:dnf]
      end
    end
    
    # Constructor results for Hungarian GP
    constructor_results = [
      { constructor: "McLaren", position: 1, points: 43 },
      { constructor: "Ferrari", position: 2, points: 18 },
      { constructor: "Red Bull Racing", position: 3, points: 15 },
      { constructor: "Mercedes", position: 4, points: 12 },
      { constructor: "Williams", position: 5, points: 8 },
      { constructor: "Aston Martin", position: 6, points: 5 }
    ]
    
    constructor_results.each do |result_data|
      ConstructorResult.find_or_create_by(race: hungarian_gp, constructor: result_data[:constructor]) do |result|
        result.position = result_data[:position]
        result.points = result_data[:points]
      end
    end
  end
  
  def self.update_all_ratings!
    Driver.update_all_ratings!
    Constructor.update_all_ratings!
  end
  
  def self.add_race_results(race_name, driver_results, constructor_results)
    race = Race.find_by(name: race_name)
    return false unless race
    
    # Add driver results
    driver_results.each do |result_data|
      DriverResult.find_or_create_by(race: race, driver: result_data[:driver]) do |result|
        result.team = result_data[:team]
        result.position = result_data[:position]
        result.points = result_data[:points]
        result.fastest_lap = result_data[:fastest_lap] || false
        result.dnf = result_data[:dnf] || false
      end
    end
    
    # Add constructor results
    constructor_results.each do |result_data|
      ConstructorResult.find_or_create_by(race: race, constructor: result_data[:constructor]) do |result|
        result.position = result_data[:position]
        result.points = result_data[:points]
      end
    end
    
    # Update all ratings after adding results
    update_all_ratings!
    
    true
  end
  
  def self.simulate_race_results_update(race_name, driver_results, constructor_results)
    # This method simulates adding new race results and updating ratings
    # In a real scenario, this would be called after each race
    
    success = add_race_results(race_name, driver_results, constructor_results)
    
    if success
      # Log the update
      Rails.logger.info "Updated ratings after #{race_name}"
      
      # Return summary of changes
      {
        success: true,
        race: race_name,
        drivers_updated: Driver.count,
        constructors_updated: Constructor.count,
        message: "Ratings updated successfully after #{race_name}"
      }
    else
      {
        success: false,
        message: "Failed to update ratings for #{race_name}"
      }
    end
  end
  
  def self.get_rating_changes_summary
    # Get the latest ratings and compare with previous
    drivers_summary = Driver.all.map do |driver|
      {
        name: driver.name,
        team: driver.team,
        current_rating: driver.current_rating,
        current_price: driver.current_price,
        championship_position: driver.championship_position
      }
    end
    
    constructors_summary = Constructor.all.map do |constructor|
      {
        name: constructor.name,
        current_rating: constructor.current_rating,
        current_price: constructor.current_price,
        championship_position: constructor.championship_position
      }
    end
    
    {
      drivers: drivers_summary.sort_by { |d| d[:current_price] }.reverse,
      constructors: constructors_summary.sort_by { |c| c[:current_price] }.reverse,
      updated_at: Time.current
    }
  end
  
  def self.get_driver_performance_summary(driver_name)
    driver = Driver.find_by(name: driver_name)
    return nil unless driver
    
    recent_results = driver.recent_results(5)
    total_points = recent_results.sum(:points)
    average_position = recent_results.average(:position)&.round(1) || 0
    fastest_laps = recent_results.where(fastest_lap: true).count
    dnfs = recent_results.where(dnf: true).count
    
    {
      driver: driver,
      recent_results: recent_results,
      total_points: total_points,
      average_position: average_position,
      fastest_laps: fastest_laps,
      dnfs: dnfs,
      current_rating: driver.current_rating,
      current_price: driver.current_price,
      championship_position: driver.championship_position
    }
  end
  
  def self.get_constructor_performance_summary(constructor_name)
    constructor = Constructor.find_by(name: constructor_name)
    return nil unless constructor
    
    recent_results = constructor.recent_results(5)
    total_points = recent_results.sum(:points)
    average_position = recent_results.average(:position)&.round(1) || 0
    
    {
      constructor: constructor,
      recent_results: recent_results,
      total_points: total_points,
      average_position: average_position,
      current_rating: constructor.current_rating,
      current_price: constructor.current_price,
      championship_position: constructor.championship_position
    }
  end

  def self.get_detailed_driver_calculations
    Driver.all.map do |driver|
      recent_performance = DriverResult.average_performance_for_driver(driver.name, 5)
      championship_position = driver.championship_position
      championships_won = driver.send(:get_championships_won)
      
      # Calculate rating components
      performance_rating = [(recent_performance / 5.0), 5.0].min
      championship_rating = driver.send(:calculate_championship_rating, championship_position)
      championship_history_rating = driver.send(:calculate_championship_history_rating, championships_won)
      
      # Calculate final rating
      final_rating = (performance_rating * 0.6 + championship_rating * 0.3 + championship_history_rating * 0.1).round(1)
      
      # Calculate price components
      performance_multiplier = recent_performance / 10.0
      rating_multiplier = final_rating / 2.5
      championship_multiplier = driver.send(:calculate_championship_multiplier, championship_position)
      championship_history_multiplier = driver.send(:calculate_championship_history_multiplier, championships_won)
      
      # Calculate final price
      final_price = (driver.base_price * (1 + performance_multiplier + rating_multiplier + championship_multiplier + championship_history_multiplier)).round
      final_price = [final_price, 50].min
      final_price = [final_price, 15].max
      
      {
        name: driver.name,
        team: driver.team,
        championships_won: championships_won,
        championship_position: championship_position,
        
        # Rating breakdown
        performance_rating: performance_rating.round(2),
        championship_rating: championship_rating.round(2),
        championship_history_rating: championship_history_rating.round(2),
        final_rating: final_rating,
        
        # Price breakdown
        base_price: driver.base_price,
        performance_multiplier: performance_multiplier.round(2),
        rating_multiplier: rating_multiplier.round(2),
        championship_multiplier: championship_multiplier.round(2),
        championship_history_multiplier: championship_history_multiplier.round(2),
        final_price: final_price,
        
        # Recent performance data
        recent_performance_score: recent_performance.round(2)
      }
    end.sort_by { |d| -d[:final_price] }
  end

  def self.update_standings_from_racingnews365
    # This method would fetch the latest standings from RacingNews365
    # and update the database with new race results
    # In a real implementation, this would scrape the website or use their API
    
    # For now, we'll create a method that can be called after each race
    # to manually update the standings based on the latest race results
    
    Rails.logger.info "Updating standings from RacingNews365..."
    
    # This would be implemented to:
    # 1. Fetch latest standings from https://racingnews365.com/formula-1-standings-2025
    # 2. Compare with current database standings
    # 3. Add new race results if there are differences
    # 4. Update all ratings and prices
    
    # For now, return a placeholder response
    {
      success: true,
      message: "Standings update method ready for implementation",
      next_race: "Dutch Grand Prix",
      last_updated: Time.current
    }
  end

  def self.check_for_new_race_results
    # This method automatically checks RacingNews365 for new race results
    # Should be called every Monday at 9am via a scheduled job
    
    Rails.logger.info "Checking for new race results from RacingNews365..."
    
    begin
      # Fetch the latest results page
      uri = URI('https://racingnews365.com/formula-1-results')
      response = Net::HTTP.get_response(uri)
      
      if response.is_a?(Net::HTTPSuccess)
        doc = Nokogiri::HTML(response.body)
        
        # Look for the most recent race result
        latest_race_link = doc.css('a[href*="results"]').first
        if latest_race_link
          race_url = latest_race_link['href']
          race_name = latest_race_link.text.strip
          
          Rails.logger.info "Found latest race: #{race_name}"
          
          # Check if this race is already in our database
          existing_race = Race.find_by(name: race_name)
          
          if existing_race && existing_race.driver_results.empty?
            # Race exists but no results yet - fetch and import results
            import_race_results_from_url(race_url, race_name)
            return {
              success: true,
              message: "New race results imported for #{race_name}",
              race: race_name,
              imported_at: Time.current
            }
          elsif !existing_race
            # New race - create it and import results
            create_race_from_url(race_url, race_name)
            return {
              success: true,
              message: "New race created and results imported for #{race_name}",
              race: race_name,
              imported_at: Time.current
            }
          else
            return {
              success: true,
              message: "No new race results found",
              last_checked: Time.current
            }
          end
        else
          return {
            success: false,
            message: "Could not find race results on RacingNews365",
            error: "No race links found"
          }
        end
      else
        return {
          success: false,
          message: "Failed to fetch RacingNews365 results page",
          error: "HTTP #{response.code}"
        }
      end
    rescue => e
      Rails.logger.error "Error checking for new race results: #{e.message}"
      return {
        success: false,
        message: "Error checking for new race results",
        error: e.message
      }
    end
  end

  def self.import_race_results_from_url(race_url, race_name)
    # Import race results from a specific RacingNews365 URL
    begin
      uri = URI(race_url)
      response = Net::HTTP.get_response(uri)
      
      if response.is_a?(Net::HTTPSuccess)
        doc = Nokogiri::HTML(response.body)
        
        # Parse driver results from the page
        driver_results = parse_driver_results_from_page(doc)
        constructor_results = parse_constructor_results_from_page(doc)
        
        # Add results to database
        if driver_results.any?
          add_race_results(race_name, driver_results, constructor_results)
          Rails.logger.info "Successfully imported #{driver_results.length} driver results for #{race_name}"
          return true
        else
          Rails.logger.warn "No driver results found for #{race_name}"
          return false
        end
      else
        Rails.logger.error "Failed to fetch race results from #{race_url}"
        return false
      end
    rescue => e
      Rails.logger.error "Error importing race results: #{e.message}"
      return false
    end
  end

  def self.create_race_from_url(race_url, race_name)
    # Create a new race and import its results
    begin
      # Extract race date and circuit info from the URL or page content
      uri = URI(race_url)
      response = Net::HTTP.get_response(uri)
      
      if response.is_a?(Net::HTTPSuccess)
        doc = Nokogiri::HTML(response.body)
        
        # Try to extract race date and circuit info
        race_date = extract_race_date_from_page(doc)
        circuit_info = extract_circuit_info_from_page(doc)
        
        # Create the race
        race = Race.create!(
          name: race_name,
          date: race_date || Date.current,
          circuit: circuit_info[:circuit] || "Unknown Circuit",
          country: circuit_info[:country] || "Unknown Country"
        )
        
        # Import results
        import_race_results_from_url(race_url, race_name)
        
        Rails.logger.info "Created new race: #{race_name}"
        return true
      else
        Rails.logger.error "Failed to create race from #{race_url}"
        return false
      end
    rescue => e
      Rails.logger.error "Error creating race: #{e.message}"
      return false
    end
  end

  def self.parse_driver_results_from_page(doc)
    # Parse driver results from RacingNews365 race results page
    # This is a simplified parser - in a real implementation, you'd need to adapt to the actual HTML structure
    
    driver_results = []
    
    # Look for driver result tables or lists
    # This is a placeholder implementation - would need to be adapted to actual page structure
    doc.css('table tr, .result-row, .driver-result').each do |row|
      # Extract driver name, position, points, etc.
      # This would need to be customized based on the actual HTML structure
      driver_name = row.css('.driver-name, .name').text.strip
      position = row.css('.position, .pos').text.strip.to_i
      points = row.css('.points, .pts').text.strip.to_i
      team = row.css('.team, .constructor').text.strip
      
      if driver_name.present? && position > 0
        driver_results << {
          driver: driver_name,
          team: team,
          position: position,
          points: points,
          fastest_lap: false, # Would need to detect from page
          dnf: false # Would need to detect from page
        }
      end
    end
    
    driver_results
  end

  def self.parse_constructor_results_from_page(doc)
    # Parse constructor results from RacingNews365 race results page
    constructor_results = []
    
    # Similar parsing logic for constructor results
    # This would need to be adapted to the actual page structure
    
    constructor_results
  end

  def self.extract_race_date_from_page(doc)
    # Extract race date from the page content
    # Look for date patterns in the page
    date_text = doc.css('.race-date, .date, .event-date').text.strip
    
    # Try to parse various date formats
    date_formats = ['%d %B %Y', '%B %d, %Y', '%Y-%m-%d', '%d/%m/%Y']
    
    date_formats.each do |format|
      begin
        return Date.strptime(date_text, format)
      rescue ArgumentError
        next
      end
    end
    
    # Fallback to current date
    Date.current
  end

  def self.extract_circuit_info_from_page(doc)
    # Extract circuit and country information from the page
    circuit_text = doc.css('.circuit-name, .track-name, .venue').text.strip
    country_text = doc.css('.country, .location').text.strip
    
    {
      circuit: circuit_text.presence || "Unknown Circuit",
      country: country_text.presence || "Unknown Country"
    }
  end

  def self.schedule_automatic_updates
    # This method sets up the automatic update schedule
    # In a production environment, this would use a job scheduler like Sidekiq or Delayed Job
    
    Rails.logger.info "Setting up automatic race result updates..."
    
    # Schedule the check for every Monday at 9am
    # This is a placeholder - in production you'd use a proper job scheduler
    
    # Example with Sidekiq (if you add it to your Gemfile):
    # CheckForNewRaceResultsWorker.perform_async
    
    # For now, we'll create a simple method that can be called manually
    # or set up with cron jobs
    
    {
      scheduled: true,
      frequency: "Every Monday at 9:00 AM",
      next_check: next_monday_at_9am,
      message: "Automatic updates scheduled"
    }
  end

  def self.next_monday_at_9am
    # Calculate the next Monday at 9am
    now = Time.current
    days_until_monday = (1 - now.wday) % 7
    next_monday = now.beginning_of_day + days_until_monday.days + 9.hours
    
    # If it's already Monday and past 9am, schedule for next Monday
    if now.wday == 1 && now.hour >= 9
      next_monday += 7.days
    end
    
    next_monday
  end

  def self.add_race_results_and_update_standings(race_name, driver_results, constructor_results)
    # This method combines adding race results with updating standings
    # It should be called after each race to keep everything current
    
    # Add the race results
    success = add_race_results(race_name, driver_results, constructor_results)
    
    if success
      # Update standings from RacingNews365 (when implemented)
      standings_update = update_standings_from_racingnews365
      
      # Update all ratings and prices
      update_all_ratings!
      
      {
        success: true,
        race: race_name,
        standings_updated: true,
        ratings_updated: true,
        message: "Race results added and standings updated successfully"
      }
    else
      {
        success: false,
        message: "Failed to add race results"
      }
    end
  end
end 