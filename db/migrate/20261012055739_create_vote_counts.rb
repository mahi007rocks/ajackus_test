class CreateVoteCounts < ActiveRecord::Migration[8.1]
  def change
    create_table :vote_counts do |t|
      t.belongs_to :event, index: { unique: true }, null: false, foreign_key: true
      t.integer :upvotes_count, default: 0, null: false
      t.integer :downvotes_count, default: 0, null: false
      t.integer :score, default: 0, null: false

      t.timestamps
    end
  end
end
