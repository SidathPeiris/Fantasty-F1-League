class CreateRaces < ActiveRecord::Migration[8.0]
  def change
    create_table :races do |t|
      t.string :name
      t.date :date
      t.string :circuit
      t.string :country

      t.timestamps
    end
  end
end
