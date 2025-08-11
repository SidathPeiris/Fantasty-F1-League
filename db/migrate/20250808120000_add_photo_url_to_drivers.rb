class AddPhotoUrlToDrivers < ActiveRecord::Migration[8.0]
  def change
    add_column :drivers, :photo_url, :string
  end
end


