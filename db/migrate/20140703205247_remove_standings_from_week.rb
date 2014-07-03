class RemoveStandingsFromWeek < ActiveRecord::Migration
  def change
    remove_column :weeks, :standings
  end
end
