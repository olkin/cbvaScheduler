class DropTierSettingsTable < ActiveRecord::Migration
  def up
    #drop_table :tier_settings
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

