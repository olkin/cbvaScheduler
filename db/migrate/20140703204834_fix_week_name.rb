class FixWeekName < ActiveRecord::Migration
  def change
    rename_column :standings, :week, :week_id
  end
end
