class FeedSerializer
  def initialize(feed_items)
    @feed_items = feed_items
  end

  def as_json(*)
    @feed_items.map do |item|
      post = item.post

      {
        id: post.id,
        user: {
          id: post.user.id,
          name: "#{post.user.first_name} #{post.user.last_name}"
        },
        title: post.title,
        description: post.description,
        image_url: post.image_url,

        likes_count: post.likes_count,
        comments_count: post.comments_count,

        viewer_has_liked: post.likes.exists?(user_id: item.user_id),

        created_at: post.created_at
      }
    end
  end
end
