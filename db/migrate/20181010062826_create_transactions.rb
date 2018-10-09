class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions, id: :uuid do |t|
      t.string :ext_id
      t.string :state
      t.boolean :approved
      t.timestamp :date
      t.jsonb :properties
      t.references :account, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
