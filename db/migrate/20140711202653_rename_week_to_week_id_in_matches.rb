class RenameWeekToWeekIdInMatches < ActiveRecord::Migration
  def change
    rename_column :matches, :week, :week_id
  end
end
