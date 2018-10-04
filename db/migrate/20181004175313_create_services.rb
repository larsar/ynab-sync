class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services, id: :uuid do |t|
      t.string :type
      t.string :name
      t.references :user, type: :uuid, foreign_key: true
      t.jsonb :config
      t.timestamps
    end
  end
end
