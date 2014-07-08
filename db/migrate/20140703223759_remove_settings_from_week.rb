class RemoveSettingsFromWeek < ActiveRecord::Migration
  def change
    remove_column :weeks, :settings
  end
end
