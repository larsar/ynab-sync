class AddImportIdToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :import_id, :string
  end
end
