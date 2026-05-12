class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true

  has_many :likes, as: :likeable, dependent: :destroy

  validates :body, presence: true
end