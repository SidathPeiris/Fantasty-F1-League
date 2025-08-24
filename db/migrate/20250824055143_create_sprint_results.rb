class CreateSprintResults < ActiveRecord::Migration[8.0]
  def change
    create_table :sprint_results do |t|
      t.references :race, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: true
      t.integer :position
      t.integer :points

      t.timestamps
    end
  end
end
