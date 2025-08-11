#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'fileutils'
require 'open-uri'
require 'nokogiri'

# Download Real F1 Constructor Logos
# Gets actual team logos from formula1.com

class RealF1LogoDownloader
  def initialize
    @constructors_dir = 'tmp/f1_images/constructors'
    FileUtils.mkdir_p(@constructors_dir)
    @successful_downloads = 0
  end

  def download_all_logos
    puts "🏎️ Downloading Real F1 Constructor Logos..."
    puts "=" * 50
    
    # Direct approach - try to get logos from the main teams page
    main_page_url = "https://www.formula1.com/en/teams"
    
    begin
      puts "📥 Fetching main teams page..."
      uri = URI(main_page_url)
      response = Net::HTTP.get_response(uri)
      
      if response.is_a?(Net::HTTPSuccess)
        html = response.body
        doc = Nokogiri::HTML(html)
        
        # Look for team logos in the main content
        team_sections = doc.css('[class*="team"], [class*="Team"], .team-card, .team-info')
        
        puts "Found #{team_sections.length} potential team sections"
        
        # Try to find images that look like team logos
        all_images = doc.css('img')
        logo_images = all_images.select do |img|
          src = img['src']&.downcase || ''
          alt = img['alt']&.downcase || ''
          
          # Look for images that might be team logos
          src.include?('team') || 
          src.include?('logo') || 
          src.include?('brand') ||
          alt.include?('team') ||
          alt.include?('logo') ||
          alt.include?('brand')
        end
        
        puts "Found #{logo_images.length} potential logo images"
        
        # Download any found logos
        logo_images.each_with_index do |img, index|
          src = img['src']
          next unless src
          
          # Convert relative URLs to absolute
          if src.start_with?('/')
            src = "https://www.formula1.com#{src}"
          elsif !src.start_with?('http')
            src = "https://www.formula1.com/#{src}"
          end
          
          filename = "team_logo_#{index + 1}.png"
          filepath = File.join(@constructors_dir, filename)
          
          begin
            URI.open(src) do |file|
              File.open(filepath, "wb") { |output| output.write(file.read) }
            end
            puts "✅ Downloaded: #{filename} from #{src}"
            @successful_downloads += 1
          rescue => e
            puts "❌ Failed to download #{filename}: #{e.message}"
          end
        end
        
        # If no logos found, try alternative approach
        if logo_images.empty?
          puts "No logos found, trying alternative approach..."
          try_alternative_downloads
        end
        
      else
        puts "❌ Failed to fetch main page: #{response.code}"
        try_alternative_downloads
      end
      
    rescue => e
      puts "❌ Error fetching main page: #{e.message}"
      try_alternative_downloads
    end
    
    puts "\n📊 Download Summary:"
    puts "=" * 50
    puts "✅ Successful downloads: #{@successful_downloads}"
  end

  private

  def try_alternative_downloads
    puts "🔄 Trying alternative download methods..."
    
    # Try to download from known F1 media URLs
    known_logos = {
      "Red Bull Racing" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/teams/2023/red-bull-racing.png.transform/2col/image.png",
      "McLaren" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/teams/2023/mclaren.png.transform/2col/image.png",
      "Ferrari" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/teams/2023/ferrari.png.transform/2col/image.png",
      "Mercedes" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/teams/2023/mercedes.png.transform/2col/image.png",
      "Aston Martin" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/teams/2023/aston-martin.png.transform/2col/image.png",
      "Williams" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/teams/2023/williams.png.transform/2col/image.png",
      "Alpine" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/teams/2023/alpine.png.transform/2col/image.png",
      "Haas" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245035/content/dam/fom-website/teams/2023/haas.png.transform/2col/image.png"
    }
    
    known_logos.each do |team_name, logo_url|
      filename = "#{team_name.gsub(' ', '_').downcase}.png"
      filepath = File.join(@constructors_dir, filename)
      
      begin
        URI.open(logo_url) do |file|
          File.open(filepath, "wb") { |output| output.write(file.read) }
        end
        puts "✅ Downloaded: #{team_name}"
        @successful_downloads += 1
      rescue => e
        puts "❌ Failed to download #{team_name}: #{e.message}"
      end
    end
  end
end

# Run the downloader
if __FILE__ == $0
  downloader = RealF1LogoDownloader.new
  downloader.download_all_logos
end
