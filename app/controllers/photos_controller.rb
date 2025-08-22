class PhotosController < ApplicationController
  def driver
    driver = Driver.find_by(id: params[:id])
    
    if driver && driver.photo.attached?
      # Get the blob and send the file directly
      blob = driver.photo.blob
      send_file blob.service.path_for(blob.key), 
                type: blob.content_type, 
                disposition: 'inline',
                filename: blob.filename.to_s
    else
      # Return a 404 or placeholder
      head :not_found
    end
  end
end
