class AddCycleToTierSettings < ActiveRecord::Migration
  def change
    add_column :tier_settings, :cycle, :integer
  end
end
