class AddSprintRaceToRaces < ActiveRecord::Migration[8.0]
  def change
    add_column :races, :sprint_race, :boolean
  end
end
