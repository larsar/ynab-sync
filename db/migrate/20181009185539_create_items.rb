class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items, id: :uuid do |t|
      t.string :type
      t.string :ext_id
      t.timestamp :date
      t.float :amount
      t.references :collection, null: false, type: :uuid, foreign_key: true
      t.jsonb :properties
      t.timestamps
    end
  end
end
