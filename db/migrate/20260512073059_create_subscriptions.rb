class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :followed_user, null: false

      t.timestamps
    end

    add_index :subscriptions, [ :user_id, :followed_user_id ], unique: true, name: "index_unique_follow"
  end
end
