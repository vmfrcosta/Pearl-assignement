class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.references :vault, null: false, foreign_key: true
      t.string :name, null: false
      t.string :file_url, null: false, default: ""
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end
  end
end
