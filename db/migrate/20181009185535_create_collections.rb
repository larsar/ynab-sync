class CreateCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :collections, id: :uuid do |t|
      t.string :type
      t.string :name
      t.string :ext_id
      t.references :source, null: false, type: :uuid, foreign_key: true
      t.jsonb :properties
      t.timestamps
    end
  end
end
