class CreateSeasonResetLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :season_reset_logs do |t|
      t.integer :year
      t.integer :teams_deleted
      t.date :reset_date

      t.timestamps
    end
  end
end
