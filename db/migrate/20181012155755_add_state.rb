class AddState < ActiveRecord::Migration[5.2]
  def change
    add_column :budgets, :enabled, :boolean, default: true
    add_column :accounts, :enabled, :boolean, default: true
    add_column :sources, :enabled, :boolean, default: true
    add_column :collections, :enabled, :boolean, default: true
  end
end
