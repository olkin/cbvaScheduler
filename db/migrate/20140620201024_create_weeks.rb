class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.integer :league_id
      t.integer :week
      t.integer :cycle
      t.text :settings
      t.text :standings

      t.timestamps
    end
  end
end
