class CreateTeamSelections < ActiveRecord::Migration[8.0]
  def change
    create_table :team_selections do |t|
      t.references :team, null: false, foreign_key: true
      t.references :selectable, polymorphic: true, null: false # Driver or Constructor
      t.integer :cost, null: false
      t.timestamps
    end
    
    add_index :team_selections, [:team_id, :selectable_type, :selectable_id], unique: true, name: 'index_team_selections_unique'
  end
end

