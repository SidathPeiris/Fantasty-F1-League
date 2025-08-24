class AddTeamColorToConstructors < ActiveRecord::Migration[8.0]
  def change
    add_column :constructors, :team_color, :string
  end
end
