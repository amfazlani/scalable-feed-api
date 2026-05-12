require "rails_helper"

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }

  it "enqueues fanout job after creation" do
    expect(FanoutFeedJob).to receive(:perform_later)

    create(:post, user: user)
  end
end
