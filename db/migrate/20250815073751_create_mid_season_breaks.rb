class CreateMidSeasonBreaks < ActiveRecord::Migration[8.0]
  def change
    create_table :mid_season_breaks do |t|
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
