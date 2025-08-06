class CreateDrivers < ActiveRecord::Migration[8.0]
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :team
      t.integer :base_price
      t.decimal :current_rating
      t.integer :current_price

      t.timestamps
    end
  end
end
