class AddExtIdToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :ext_id, :string
  end
end
