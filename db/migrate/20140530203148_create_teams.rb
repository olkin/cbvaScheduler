class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :captain
      t.string :email
      t.integer :league_id

      t.timestamps
    end
  end
end
