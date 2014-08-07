class MatchByStanding < ActiveRecord::Migration
  def change
    remove_column :matches, :team1_id
    remove_column :matches, :team2_id
    remove_column :matches, :week_id
    add_column :matches, :standing1_id, :integer
    add_column :matches, :standing2_id, :integer
  end
end
