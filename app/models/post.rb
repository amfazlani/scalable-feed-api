class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  has_many :commenters, through: :comments, source: :user

  after_create_commit :fanout_to_followers_feed

  validates :image_url, presence: true

  def fanout_to_followers_feed
    FanoutFeedJob.perform_later(id)
  end

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end
end