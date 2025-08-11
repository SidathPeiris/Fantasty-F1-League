module ApplicationHelper
  include Rails.application.routes.url_helpers
  
  def get_rating_color(rating)
    if rating >= 4.8
      '#eab308' # Gold for highest rated (4.8+)
    elsif rating > 4.0
      '#15803d' # British racing green for above 4
    elsif rating >= 2.0 && rating <= 4.0
      '#2563eb' # Blue for 2-4
    else
      '#dc2626' # Red for below 2
    end
  end

  def get_driver_photo_url(driver_name)
    # Get Active Storage photo URL
    driver = Driver.find_by(name: driver_name)
    if driver&.photo&.attached?
      return rails_blob_url(driver.photo, host: 'localhost:3000')
    end
    
    # Return nil if no Active Storage photo
    nil
  end

  def get_constructor_logo_url(constructor_name)
    # Get Active Storage logo URL
    constructor = Constructor.find_by(name: constructor_name)
    if constructor&.logo&.attached?
      return rails_blob_url(constructor.logo, host: 'localhost:3000')
    end
    
    # Return nil if no Active Storage logo
    nil
  end
end
