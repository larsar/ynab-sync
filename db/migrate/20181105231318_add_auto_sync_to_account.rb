class AddAutoSyncToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :auto_sync, :boolean, default: false
  end
end
