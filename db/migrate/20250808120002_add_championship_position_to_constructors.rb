class AddChampionshipPositionToConstructors < ActiveRecord::Migration[8.0]
  def change
    add_column :constructors, :championship_position, :integer
  end
end
