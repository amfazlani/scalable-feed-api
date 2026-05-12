class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true

      t.string :title
      t.text :description
      t.string :image_url

      t.integer :likes_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0

      t.timestamps
    end

    add_index :posts, [ :user_id, :created_at ]
  end
end
