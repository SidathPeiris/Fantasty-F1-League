class AddOfficialF1ImageUrls < ActiveRecord::Migration[8.0]
  def change
    add_column :drivers, :official_photo_url, :string
    add_column :constructors, :official_logo_url, :string
  end
end
