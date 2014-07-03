class CreateTierSettings < ActiveRecord::Migration
  def change
    create_table :tier_settings do |t|
      t.integer :week_id
      t.integer :tier
      t.integer :total_teams
      t.integer :teams_down
      t.string :day
      t.text :schedule_pattern

      t.timestamps
    end
  end
end
