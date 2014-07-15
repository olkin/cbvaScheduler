class RemoveCycleFromWeek < ActiveRecord::Migration
  def change
    remove_column :weeks, :cycle
  end
end
