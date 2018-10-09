class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :name
      t.jsonb :properties
      t.references :budget, type: :uuid, foreign_key: true
      t.references :collection, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
