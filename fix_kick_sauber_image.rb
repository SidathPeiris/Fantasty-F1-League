#!/usr/bin/env ruby

# Fix Kick Sauber Image - Reattach a car image
# This script reattaches a car image to the Kick Sauber constructor

class KickSauberImageFixer
  def initialize
    @cars_dir = 'tmp/f1_images/cars'
    @fixed = false
  end

  def fix_kick_sauber_image
    puts "🔧 Fixing Kick Sauber constructor image..."
    puts "=" * 50
    
    # Find Kick Sauber constructor
    constructor = Constructor.find_by(name: 'Kick Sauber')
    if constructor
      puts "✅ Found Kick Sauber constructor"
      
      # Find a suitable car image (use f1_car_38.png which was previously mapped to Kick Sauber)
      car_image_path = File.join(@cars_dir, 'f1_car_38.png')
      
      if File.exist?(car_image_path)
        puts "✅ Found car image: f1_car_38.png"
        
        begin
          # Remove any existing logo attachment
          constructor.logo.purge if constructor.logo.attached?
          
          # Attach new car image
          constructor.logo.attach(
            io: File.open(car_image_path),
            filename: 'kicksauber_car.png',
            content_type: 'image/png'
          )
          
          puts "✅ Successfully attached car image to Kick Sauber"
          puts "   Blob ID: #{constructor.logo.attachment.blob_id}"
          @fixed = true
          
        rescue => e
          puts "❌ Failed to attach image: #{e.message}"
        end
      else
        puts "❌ Car image not found: #{car_image_path}"
        
        # Try alternative images
        alternative_images = ['f1_car_76.png', 'f1_car_38.png', 'f1_car_17.png']
        
        alternative_images.each do |alt_img|
          alt_path = File.join(@cars_dir, alt_img)
          if File.exist?(alt_path)
            puts "🔄 Trying alternative image: #{alt_img}"
            
            begin
              constructor.logo.purge if constructor.logo.attached?
              
              constructor.logo.attach(
                io: File.open(alt_path),
                filename: 'kicksauber_car.png',
                content_type: 'image/png'
              )
              
              puts "✅ Successfully attached alternative image: #{alt_img}"
              puts "   Blob ID: #{constructor.logo.attachment.blob_id}"
              @fixed = true
              break
              
            rescue => e
              puts "❌ Failed to attach #{alt_img}: #{e.message}"
            end
          end
        end
      end
    else
      puts "❌ Kick Sauber constructor not found"
    end
    
    puts "\n📊 Fix Summary:"
    puts "=" * 50
    if @fixed
      puts "✅ Kick Sauber image fixed successfully!"
    else
      puts "❌ Failed to fix Kick Sauber image"
    end
  end
end

# Run the fixer
if __FILE__ == $0
  puts "Loading Rails environment..."
  require_relative 'config/environment'
  
  fixer = KickSauberImageFixer.new
  fixer.fix_kick_sauber_image
end
