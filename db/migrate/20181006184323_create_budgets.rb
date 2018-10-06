class CreateBudgets < ActiveRecord::Migration[5.2]
  def change
    create_table :budgets, id: :uuid do |t|
      t.string :name
      t.references :user, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
