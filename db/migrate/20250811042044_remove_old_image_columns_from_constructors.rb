class RemoveOldImageColumnsFromConstructors < ActiveRecord::Migration[8.0]
  def change
    remove_column :constructors, :photo_url, :string
    remove_column :constructors, :official_photo_url, :string
  end
end
