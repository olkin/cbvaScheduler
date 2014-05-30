class AddStartDateToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :start_date, :date
  end
end
