class CreateApiKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :api_keys do |t|
      t.references :user, null: false, foreign_key: true
      t.string :secret, null: false
      t.boolean :shareable, default: true, null: false

      t.timestamps
    end
  end
end
