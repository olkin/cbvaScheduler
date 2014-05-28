class CreateLeagueTypes < ActiveRecord::Migration
  def change
    create_table :league_types do |t|
      t.string :desc
      t.string :description

      t.timestamps
    end
  end
end
