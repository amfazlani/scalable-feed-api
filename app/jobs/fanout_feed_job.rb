class FanoutFeedJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find(post_id)

    post.user.followers.find_each do |follower|
      FeedItem.create!(
        user_id: follower.id,
        post_id: post.id,
        created_at: post.created_at
      )
    end
  end
end