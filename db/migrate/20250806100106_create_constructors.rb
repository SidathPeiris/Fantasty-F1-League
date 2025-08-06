class CreateConstructors < ActiveRecord::Migration[8.0]
  def change
    create_table :constructors do |t|
      t.string :name
      t.integer :base_price
      t.decimal :current_rating
      t.integer :current_price

      t.timestamps
    end
  end
end
