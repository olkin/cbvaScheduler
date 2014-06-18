class AddGameToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :game, :integer
  end
end
