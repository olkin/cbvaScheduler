class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :team1_id
      t.integer :team2_id
      t.string :score
      t.integer :court
      t.integer :week

      t.timestamps
    end
  end
end
