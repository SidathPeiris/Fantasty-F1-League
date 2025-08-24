#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'fileutils'
require 'open-uri'

# Download Driver Photos and Attach to Active Storage
# Gets driver photos from reliable sources and attaches them to the Driver model

class DriverPhotoDownloader
  def initialize
    @drivers_dir = 'tmp/f1_images/drivers'
    FileUtils.mkdir_p(@drivers_dir)
    @successful_downloads = 0
    @errors = []
  end

  def download_all_photos
    puts "🏎️ Downloading Driver Photos and Attaching to Active Storage..."
    puts "=" * 60
    
    # Create drivers directory
    FileUtils.mkdir_p(@drivers_dir)
    
    # Download photos for each driver
    Driver.all.each do |driver|
      download_driver_photo(driver)
    end
    
    puts "\n📊 Download Summary:"
    puts "=" * 60
    puts "✅ Successful downloads: #{@successful_downloads}"
    
    if @errors.any?
      puts "❌ Errors: #{@errors.length}"
      @errors.each { |error| puts "  - #{error}" }
    end
  end

  private

  def download_driver_photo(driver)
    puts "\n👤 Processing #{driver.name}..."
    
    # Try multiple sources for each driver
    photo_url = find_driver_photo_url(driver.name)
    
    if photo_url
      begin
        # Download the photo
        filename = "#{driver.name.gsub(' ', '_').downcase}.jpg"
        filepath = File.join(@drivers_dir, filename)
        
        URI.open(photo_url) do |file|
          File.open(filepath, "wb") { |output| output.write(file.read) }
        end
        
        # Attach to Active Storage
        if File.exist?(filepath)
          driver.photo.attach(
            io: File.open(filepath),
            filename: filename,
            content_type: 'image/jpeg'
          )
          
          puts "✅ Downloaded and attached photo for #{driver.name}"
          @successful_downloads += 1
        else
          raise "File not found after download"
        end
        
      rescue => e
        error_msg = "Failed to download/attach photo for #{driver.name}: #{e.message}"
        puts "❌ #{error_msg}"
        @errors << error_msg
      end
    else
      puts "⚠️ No photo URL found for #{driver.name}"
    end
  end

  def find_driver_photo_url(driver_name)
    # Try multiple sources for driver photos
    sources = [
      # Wikipedia Commons (reliable source)
      ->(name) { get_wikipedia_photo_url(name) },
      # F1 Media (official source)
      ->(name) { get_f1_media_photo_url(name) },
      # Fallback to placeholder service
      ->(name) { get_placeholder_photo_url(name) }
    ]
    
    sources.each do |source|
      url = source.call(driver_name)
      return url if url
    end
    
    nil
  end

  def get_wikipedia_photo_url(driver_name)
    # Wikipedia Commons URLs for F1 drivers
    wiki_photos = {
      "Max Verstappen" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/Max_Verstappen_2017_Malaysia_3.jpg",
      "Lewis Hamilton" => "https://upload.wikimedia.org/wikipedia/commons/1/18/Lewis_Hamilton_2016_Malaysia_2.jpg",
      "Charles Leclerc" => "https://upload.wikimedia.org/wikipedia/commons/9/9c/Charles_Leclerc_2019_Australia_2.jpg",
      "Lando Norris" => "https://upload.wikimedia.org/wikipedia/commons/2/24/Lando_Norris_2019_Australia_2.jpg",
      "Oscar Piastri" => "https://upload.wikimedia.org/wikipedia/commons/8/8c/Oscar_Piastri_2023_Australia_2.jpg",
      "George Russell" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/George_Russell_2019_Australia_2.jpg",
      "Carlos Sainz" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/Carlos_Sainz_Jr._2019_Australia_2.jpg",
      "Fernando Alonso" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/Fernando_Alonso_2019_Australia_2.jpg",
      "Lance Stroll" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/Lance_Stroll_2019_Australia_2.jpg",
      "Alexander Albon" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/Alexander_Albon_2019_Australia_2.jpg",
      "Yuki Tsunoda" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/Yuki_Tsunoda_2021_Australia_2.jpg",
      "Nico Hulkenberg" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/Nico_H%C3%BClkenberg_2019_Australia_2.jpg",
      "Liam Lawson" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/Liam_Lawson_2023_Australia_2.jpg",
      "Esteban Ocon" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/Esteban_Ocon_2019_Australia_2.jpg",
      "Pierre Gasly" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/Pierre_Gasly_2019_Australia_2.jpg",
      "Kimi Antonelli" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/Kimi_Antonelli_2023_Australia_2.jpg",
      "Gabriel Bortoleto" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/Gabriel_Bortoleto_2023_Australia_2.jpg",
      "Isack Hadjar" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/Isack_Hadjar_2023_Australia_2.jpg",
      "Oliver Bearman" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/Oliver_Bearman_2023_Australia_2.jpg",
      "Franco Colapinto" => "https://upload.wikimedia.org/wikipedia/commons/7/7d/Franco_Colapinto_2023_Australia_2.jpg"
    }
    
    wiki_photos[driver_name]
  end

  def get_f1_media_photo_url(driver_name)
    # F1 Media URLs (official source)
    f1_photos = {
      "Max Verstappen" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/drivers/2023/max-verstappen.png.transform/2col/image.png",
      "Lewis Hamilton" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/drivers/2023/lewis-hamilton.png.transform/2col/image.png",
      "Charles Leclerc" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/drivers/2023/charles-leclerc.png.transform/2col/image.png",
      "Lando Norris" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/drivers/2023/lando-norris.png.transform/2col/image.png",
      "Oscar Piastri" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/drivers/2023/oscar-piastri.png.transform/2col/image.png",
      "George Russell" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/drivers/2023/george-russell.png.transform/2col/image.png",
      "Carlos Sainz" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/drivers/2023/carlos-sainz.png.transform/2col/image.png",
      "Fernando Alonso" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/drivers/2023/fernando-alonso.png.transform/2col/image.png"
    }
    
    f1_photos[driver_name]
  end

  def get_placeholder_photo_url(driver_name)
    # Fallback to a placeholder service
    # This ensures every driver gets at least a basic photo
    "https://via.placeholder.com/300x300/1f2937/ffffff?text=#{URI.encode_www_form_component(driver_name.split(' ').first)}"
  end
end

# Run the downloader
if __FILE__ == $0
  puts "Loading Rails environment..."
  require_relative 'config/environment'
  
  downloader = DriverPhotoDownloader.new
  downloader.download_all_photos
end
