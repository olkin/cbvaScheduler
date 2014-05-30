class RenameLeagueTypeToLeague < ActiveRecord::Migration
  def change
    rename_table :league_types, :leagues
  end
end
