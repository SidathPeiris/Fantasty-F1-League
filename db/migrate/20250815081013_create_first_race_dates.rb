class CreateFirstRaceDates < ActiveRecord::Migration[8.0]
  def change
    create_table :first_race_dates do |t|
      t.date :race_date
      t.integer :season_year

      t.timestamps
    end
  end
end
