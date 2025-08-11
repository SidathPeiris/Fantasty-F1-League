class Api::V1::ConstructorsController < Api::V1::BaseController
  def index
    constructors = Constructor.select(:id, :name, :current_rating, :base_price, :championship_position)
    render json: constructors.map { |c| 
      c.as_json.merge(
        current_price: c.current_price,
        logo_url: c.logo.attached? ? rails_blob_url(c.logo) : nil
      )
    }
  end

  def show
    constructor = Constructor.find(params[:id])
    render json: constructor.as_json(only: [:id, :name, :current_rating, :base_price])
                          .merge(
                            current_price: constructor.current_price,
                            logo_url: constructor.logo.attached? ? rails_blob_url(constructor.logo) : nil
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


