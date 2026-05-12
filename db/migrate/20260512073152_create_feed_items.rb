class CreateFeedItems < ActiveRecord::Migration[7.1]
  def change
    create_table :feed_items do |t|
      t.references :user, null: false, foreign_key: true # feed owner
      t.references :post, null: false, foreign_key: true

      t.datetime :created_at, null: false
    end

    add_index :feed_items, [ :user_id, :created_at ]
    add_index :feed_items, [ :user_id, :post_id ], unique: true, name: "index_unique_feed_items"
  end
end
