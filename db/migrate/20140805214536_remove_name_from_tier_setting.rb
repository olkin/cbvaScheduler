class RemoveNameFromTierSetting < ActiveRecord::Migration
  def change
    remove_column :tier_settings, :name
  end
end
