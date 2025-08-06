namespace :f1 do
  desc "Check for new race results from RacingNews365"
  task check_new_results: :environment do
    puts "Checking for new F1 race results..."
    
    result = F1DataService.check_for_new_race_results
    
    if result[:success]
      if result[:race]
        puts "✅ SUCCESS: New race results found and imported!"
        puts "Race: #{result[:race]}"
        puts "Message: #{result[:message]}"
        puts "Imported at: #{result[:imported_at]}"
      else
        puts "ℹ️ INFO: No new race results found"
        puts "Last checked: #{result[:last_checked]}"
      end
    else
      puts "❌ ERROR: Failed to check for new results"
      puts "Error: #{result[:error]}"
      puts "Message: #{result[:message]}"
    end
    
    puts "Check completed at: #{Time.current}"
  end

  desc "Schedule automatic updates (for setup)"
  task schedule_updates: :environment do
    puts "Setting up automatic F1 race result updates..."
    
    schedule_info = F1DataService.schedule_automatic_updates
    
    puts "✅ Automatic updates scheduled!"
    puts "Frequency: #{schedule_info[:frequency]}"
    puts "Next check: #{schedule_info[:next_check]}"
    puts "Message: #{schedule_info[:message]}"
    
    puts "\nTo set up automatic checks, add this to your crontab:"
    puts "0 9 * * 1 cd /path/to/your/app && bin/rails f1:check_new_results"
    puts "\nOr for testing, you can run manually with:"
    puts "bin/rails f1:check_new_results"
  end

  desc "Test the race result parsing (development only)"
  task test_parsing: :environment do
    puts "Testing race result parsing from RacingNews365..."
    
    # Test the parsing functions with a sample URL
    test_url = "https://racingnews365.com/formula-1-results"
    
    begin
      uri = URI(test_url)
      response = Net::HTTP.get_response(uri)
      
      if response.is_a?(Net::HTTPSuccess)
        doc = Nokogiri::HTML(response.body)
        
        puts "✅ Successfully fetched RacingNews365 results page"
        puts "Page title: #{doc.css('title').text.strip}"
        
        # Look for race result links
        race_links = doc.css('a[href*="results"]')
        puts "Found #{race_links.length} potential race result links"
        
        if race_links.any?
          latest_link = race_links.first
          puts "Latest race link: #{latest_link.text.strip}"
          puts "URL: #{latest_link['href']}"
        end
        
      else
        puts "❌ Failed to fetch page: HTTP #{response.code}"
      end
      
    rescue => e
      puts "❌ Error testing parsing: #{e.message}"
    end
  end
end 