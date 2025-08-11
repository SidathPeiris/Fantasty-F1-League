class Update2025DriverTeams < ActiveRecord::Migration[8.0]
  def change
    # Update 2025 F1 Driver Team Assignments
    
    # Lewis Hamilton moves from Mercedes to Ferrari
    execute "UPDATE drivers SET team = 'Ferrari' WHERE name = 'Lewis Hamilton'"
    
    # Carlos Sainz moves from Ferrari to Williams
    execute "UPDATE drivers SET team = 'Williams' WHERE name = 'Carlos Sainz'"
    
    # Note: Other drivers remain in their current teams for 2025
    # - Charles Leclerc stays at Ferrari
    # - George Russell stays at Mercedes
    # - Kimi Antonelli stays at Mercedes (replacing Lewis Hamilton)
    # - Alexander Albon stays at Williams
  end
end
