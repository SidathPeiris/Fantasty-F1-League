class Api::V1::DriversController < Api::V1::BaseController
  def index
    drivers = Driver.select(:id, :name, :team, :current_rating, :base_price, :championship_position)
    render json: drivers.map { |d| 
      d.as_json.merge(
        current_price: d.current_price,
        photo_url: d.photo.attached? ? rails_blob_url(d.photo) : nil
      )
    }
  end

  def show
    driver = Driver.find(params[:id])
    render json: driver.as_json(only: [:id, :name, :team, :current_rating, :base_price])
                     .merge(
                       current_price: driver.current_price,
                       photo_url: driver.photo.attached? ? rails_blob_url(driver.photo) : nil
                     )
  end

  private

  def rails_blob_url(attachment)
    return nil unless attachment.attached?
    
    # Use the signed blob URL directly
    Rails.application.routes.url_helpers.rails_blob_url(attachment, host: request.base_url)
  rescue => e
    Rails.logger.error "Failed to generate blob URL: #{e.message}"
    nil
  end
end


