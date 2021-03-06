class CreateSources < ActiveRecord::Migration[5.2]
  def change
    create_table :sources, id: :uuid do |t|
      t.string :type
      t.string :name
      t.references :user, null: false, type: :uuid, foreign_key: true
      t.jsonb :properties
      t.timestamps
    end
  end
end
