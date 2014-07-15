class AddStatisticsToStandings < ActiveRecord::Migration
  def change
    add_column :standings, :matches_played, :integer
    add_column :standings, :matches_won, :integer
    add_column :standings, :sets_played, :integer
    add_column :standings, :sets_won, :integer
    add_column :standings, :points_diff, :integer
  end
end
