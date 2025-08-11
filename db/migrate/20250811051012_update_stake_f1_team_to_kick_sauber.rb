class UpdateStakeF1TeamToKickSauber < ActiveRecord::Migration[8.0]
  def change
    # Update Stake F1 Team to Kick Sauber
    execute "UPDATE constructors SET name = 'Kick Sauber' WHERE name = 'Stake F1 Team'"
    
    # Remove duplicate Kick Sauber if it exists
    execute "DELETE FROM constructors WHERE id NOT IN (SELECT MIN(id) FROM constructors GROUP BY name)"
  end
end
