class CreateSeasonResetMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :season_reset_messages do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :season_year
      t.boolean :message_shown

      t.timestamps
    end
  end
end
