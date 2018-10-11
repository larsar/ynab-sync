class AddItemToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_reference :transactions, :item, type: :uuid, foreign_key: true
  end
end
