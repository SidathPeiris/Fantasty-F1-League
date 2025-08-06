class CreateDriverResults < ActiveRecord::Migration[8.0]
  def change
    create_table :driver_results do |t|
      t.references :race, null: false, foreign_key: true
      t.string :driver
      t.string :team
      t.integer :position
      t.integer :points
      t.boolean :fastest_lap
      t.boolean :dnf

      t.timestamps
    end
  end
end
