class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :total_cost, null: false
      t.string :status, default: 'active' # active, archived, submitted
      t.timestamps
    end
    
    add_index :teams, [:user_id, :status]
  end
end

