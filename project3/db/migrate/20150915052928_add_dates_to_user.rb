class AddDatesToUser < ActiveRecord::Migration
  def change
    add_column :users, :start_date, :date
    add_column :users, :end_date, :date
  end
end
