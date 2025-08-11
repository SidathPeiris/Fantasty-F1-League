class RemoveOldImageColumnsFromDrivers < ActiveRecord::Migration[8.0]
  def change
    remove_column :drivers, :photo_url, :string
    remove_column :drivers, :official_photo_url, :string
  end
end
