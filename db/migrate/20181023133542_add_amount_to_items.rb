class AddAmountToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :amount, :float
  end
end
