class ChangeMatchesWonTypeInStandings < ActiveRecord::Migration
  def change
    change_column :standings, :matches_won, :decimal
  end
end
