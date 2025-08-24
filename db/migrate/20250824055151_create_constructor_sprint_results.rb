class CreateConstructorSprintResults < ActiveRecord::Migration[8.0]
  def change
    create_table :constructor_sprint_results do |t|
      t.references :race, null: false, foreign_key: true
      t.references :constructor, null: false, foreign_key: true
      t.integer :position
      t.integer :points

      t.timestamps
    end
  end
end
