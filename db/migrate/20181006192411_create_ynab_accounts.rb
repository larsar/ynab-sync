class CreateYnabAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :ynab_accounts, id: :uuid do |t|
      t.string :name
      t.references :budget, type: :uuid, foreign_key: true
      t.references :user, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
