class CreateTierSettings < ActiveRecord::Migration
  def change
    drop_table :tier_settings
    create_table :tier_settings do |t|
      t.integer :league_id
      t.integer :tier
      t.integer :total_teams
      t.integer :teams_down
      t.string :schedule_pattern

      t.timestamps
    end
  end
end
