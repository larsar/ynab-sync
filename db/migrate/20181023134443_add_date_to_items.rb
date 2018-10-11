class AddDateToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :date, :timestamp
  end
end
