class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  has_many :commenters, through: :comments, source: :user

  validates :image_url, presence: true

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end
end