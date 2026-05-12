class FeedItem < ApplicationRecord
  belongs_to :user   # feed owner (viewer)
  belongs_to :post

  validates :user_id, uniqueness: {
    scope: :post_id
  }
end
