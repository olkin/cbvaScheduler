class CreateStandings < ActiveRecord::Migration
  def change
    create_table :standings do |t|
      t.integer :team_id
      t.integer :rank
      t.integer :tier
      t.integer :week

      t.timestamps
    end
  end
end
