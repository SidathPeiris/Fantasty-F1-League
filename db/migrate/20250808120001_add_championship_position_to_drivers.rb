class AddChampionshipPositionToDrivers < ActiveRecord::Migration[8.0]
  def change
    add_column :drivers, :championship_position, :integer
  end
end
