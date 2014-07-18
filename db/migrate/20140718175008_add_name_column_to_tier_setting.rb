class AddNameColumnToTierSetting < ActiveRecord::Migration
  def change
    add_column :tier_settings, :name, :string
  end
end
