class AddMemoToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :memo, :text
  end
end
