require "rails_helper"

RSpec.describe FanoutFeedJob, type: :job do
  let(:user) { create(:user) }
  let(:follower) { create(:user) }
  let(:post) { create(:post, user: user) }

  before do
    follower.followed_users << user
  end

  it "creates feed items for followers" do
    expect {
      described_class.new.perform(post.id)
    }.to change(FeedItem, :count).by(1)

    feed_item = FeedItem.last

    expect(feed_item.user).to eq(follower)
    expect(feed_item.post).to eq(post)
  end
end
