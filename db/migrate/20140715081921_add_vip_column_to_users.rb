class AddVipColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vip, :boolean
  end
end
