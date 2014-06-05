class AddDayToTierSettings < ActiveRecord::Migration
  def change
    add_column :tier_settings, :day, :string
  end
end
