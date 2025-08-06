class CreateConstructorResults < ActiveRecord::Migration[8.0]
  def change
    create_table :constructor_results do |t|
      t.references :race, null: false, foreign_key: true
      t.string :constructor
      t.integer :position
      t.integer :points

      t.timestamps
    end
  end
end
