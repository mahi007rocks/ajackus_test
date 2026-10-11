class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :external_id, null: false
      t.string :title, null: false
      t.text :description
      t.datetime :starts_at, null: false
      t.datetime :ends_at
      t.string :image_url
      t.string :url
      t.string :location

      t.timestamps
    end
    add_index :events, :external_id, unique: true
  end
end
