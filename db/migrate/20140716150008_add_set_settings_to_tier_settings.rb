class AddSetSettingsToTierSettings < ActiveRecord::Migration
  def change
    add_column :tier_settings, :set_points, :string
    add_column :tier_settings, :match_times, :string
  end
end
