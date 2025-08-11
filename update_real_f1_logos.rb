#!/usr/bin/env ruby

# Update Constructor Logos with Real F1 Team Logos
# Replaces all old logos with the real 2025 F1 team logos

class RealF1LogoUpdater
  def initialize
    @constructors_dir = 'tmp/f1_images/constructors'
    @updated_count = 0
    @errors = []
  end

  def update_all_logos
    puts "🏎️ Updating Constructor Logos with Real 2025 F1 Team Logos..."
    puts "=" * 60
    
    # Map of constructor names to their real logo files
    # Using the actual 2025 F1 team logos we just downloaded
    logo_mapping = {
      "Red Bull Racing" => "team_logo_14.png",      # Red Bull Racing logo
      "McLaren" => "team_logo_11.png",              # McLaren logo
      "Ferrari" => "team_logo_12.png",              # Ferrari logo
      "Mercedes" => "team_logo_13.png",             # Mercedes logo
      "Aston Martin" => "team_logo_16.png",         # Aston Martin logo
      "Williams" => "team_logo_15.png",             # Williams logo
      "Stake F1 Team" => "team_logo_17.png",        # Stake F1 Team logo
      "Haas" => "team_logo_19.png",                 # Haas logo
      "Racing Bulls" => "team_logo_18.png",         # Racing Bulls logo
      "Alpine" => "team_logo_20.png",               # Alpine logo
      "Kick Sauber" => "team_logo_5.png"            # Kick Sauber logo
    }
    
    logo_mapping.each do |constructor_name, logo_filename|
      filepath = File.join(@constructors_dir, logo_filename)
      
      if File.exist?(filepath)
        begin
          constructor = Constructor.find_by(name: constructor_name)
          if constructor
            # Remove ALL existing logo attachments
            constructor.logo.purge if constructor.logo.attached?
            
            # Attach new real F1 logo
            constructor.logo.attach(
              io: File.open(filepath),
              filename: "#{constructor_name.gsub(' ', '_').downcase}.png",
              content_type: 'image/png'
            )
            
            puts "✅ Updated logo for #{constructor_name} with real F1 logo"
            @updated_count += 1
          else
            puts "⚠️ Constructor not found: #{constructor_name}"
          end
        rescue => e
          error_msg = "Failed to update logo for #{constructor_name}: #{e.message}"
          puts "❌ #{error_msg}"
          @errors << error_msg
        end
      else
        puts "⚠️ Logo file not found: #{filepath}"
      end
    end
    
    puts "\n📊 Update Summary:"
    puts "=" * 60
    puts "✅ Successfully updated: #{@updated_count}"
    
    if @errors.any?
      puts "❌ Errors: #{@errors.length}"
      @errors.each { |error| puts "  - #{error}" }
    end
    
    puts "\n🧹 Cleaning up old placeholder images..."
    cleanup_old_images
  end

  private

  def cleanup_old_images
    # Remove all old SVG files and numbered logo files
    old_files = Dir.glob(File.join(@constructors_dir, "*.svg")) + 
                Dir.glob(File.join(@constructors_dir, "team_logo_*.png"))
    
    old_files.each do |file|
      File.delete(file)
      puts "🗑️ Removed old file: #{File.basename(file)}"
    end
    
    puts "✅ Cleanup completed"
  end
end

# Run the updater
if __FILE__ == $0
  puts "Loading Rails environment..."
  require_relative 'config/environment'
  
  updater = RealF1LogoUpdater.new
  updater.update_all_logos
end
