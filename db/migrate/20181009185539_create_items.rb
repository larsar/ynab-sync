class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items, id: :uuid do |t|
      t.string :type
      t.references :collection, type: :uuid, foreign_key: true
      t.jsonb :properties
      t.timestamps
    end
  end
end
