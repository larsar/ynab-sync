# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.datetime :remember_created_at
      t.string :ynab_access_token

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
  end
end
