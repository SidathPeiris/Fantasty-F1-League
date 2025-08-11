#!/usr/bin/env ruby

# Refresh Active Storage with Professional F1 Photos
# Clears all old attachments and reattaches the new professional photos

class ActiveStorageRefresher
  def initialize
    @drivers_dir = 'tmp/f1_images/drivers'
    @constructors_dir = 'tmp/f1_images/constructors'
    @refreshed_count = 0
    @errors = []
  end

  def refresh_all_images
    puts "🏎️ Refreshing Active Storage with Professional F1 Photos..."
    puts "=" * 60
    
    refresh_driver_photos
    refresh_constructor_logos
    
    puts "\n📊 Refresh Summary:"
    puts "=" * 60
    puts "✅ Successfully refreshed: #{@refreshed_count}"
    
    if @errors.any?
      puts "❌ Errors: #{@errors.length}"
      @errors.each { |error| puts "  - #{error}" }
    end
  end

  private

  def refresh_driver_photos
    puts "\n👤 Refreshing Driver Photos..."
    puts "-" * 30
    
    Dir.glob(File.join(@drivers_dir, "*.jpg")).each do |filepath|
      filename = File.basename(filepath, ".jpg")
      driver_name = filename.gsub('_', ' ').split.map(&:capitalize).join(' ')
      
      begin
        driver = Driver.find_by(name: driver_name)
        if driver
          # Remove ALL existing photo attachments
          driver.photo.purge if driver.photo.attached?
          
          # Attach new professional photo
          driver.photo.attach(
            io: File.open(filepath),
            filename: "#{filename}.jpg",
            content_type: 'image/jpeg'
          )
          
          puts "✅ Refreshed photo for #{driver_name}"
          @refreshed_count += 1
        else
          puts "⚠️ Driver not found: #{driver_name}"
        end
      rescue => e
        error_msg = "Failed to refresh photo for #{driver_name}: #{e.message}"
        puts "❌ #{error_msg}"
        @errors << error_msg
      end
    end
  end

  def refresh_constructor_logos
    puts "\n🏭 Refreshing Constructor Logos..."
    puts "-" * 30
    
    # Map database names to file names
    constructor_file_mapping = {
      "Red Bull Racing" => "red_bull_racing",
      "McLaren" => "mclaren", 
      "Ferrari" => "ferrari",
      "Mercedes" => "mercedes",
      "Aston Martin" => "aston_martin",
      "Williams" => "williams",
      "Stake F1 Team" => "stake_f1_team",
      "Haas" => "haas",
      "Racing Bulls" => "racing_bulls",
      "Alpine" => "alpine",
      "Kick Sauber" => "kick_sauber"
    }
    
    constructor_file_mapping.each do |db_name, file_name|
      filepath = File.join(@constructors_dir, "#{file_name}.png")
      
      if File.exist?(filepath)
        begin
          constructor = Constructor.find_by(name: db_name)
          if constructor
            # Remove ALL existing logo attachments
            constructor.logo.purge if constructor.logo.attached?
            
            # Attach new logo
            constructor.logo.attach(
              io: File.open(filepath),
              filename: "#{file_name}.png",
              content_type: 'image/png'
            )
            
            puts "✅ Refreshed logo for #{db_name}"
            @refreshed_count += 1
          else
            puts "⚠️ Constructor not found: #{db_name}"
          end
        rescue => e
          error_msg = "Failed to refresh logo for #{db_name}: #{e.message}"
          puts "❌ #{error_msg}"
          @errors << error_msg
        end
      else
        puts "⚠️ Image file not found: #{filepath}"
      end
    end
  end
end

# Run the refresher
if __FILE__ == $0
  puts "Loading Rails environment..."
  require_relative 'config/environment'
  
  refresher = ActiveStorageRefresher.new
  refresher.refresh_all_images
end
