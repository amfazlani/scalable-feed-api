class User < ApplicationRecord
  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :followed_users,
           through: :subscriptions,
           source: :followed_user

  has_many :reverse_subscriptions,
           class_name: "Subscription",
           foreign_key: :followed_user_id

  has_many :followers,
           through: :reverse_subscriptions,
           source: :user

  has_many :feed_items, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  def feed_user_ids
    followed_users.select(:id)
  end
end
