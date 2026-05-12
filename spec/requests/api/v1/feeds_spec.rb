require "rails_helper"
require "sidekiq/testing"

RSpec.describe "Feeds API", type: :request do
  let!(:user) { create(:user) }
  let!(:followed_user) { create(:user) }

  around do |example|
    Sidekiq::Testing.inline! do
      example.run
    end
  end

  before do
    user.followed_users << followed_user

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user)
      .and_return(user)
  end

  describe "GET /api/v1/feed" do
    it "returns a paginated feed" do
      create(:post, user: followed_user, created_at: 2.days.ago)
      create(:post, user: followed_user, created_at: 1.day.ago)

      get "/api/v1/feed", params: { page: 1 }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).not_to be_empty
      expect(json.first["id"]).to be_present
    end

    it "returns posts in descending order" do
      post1 = create(:post, user: followed_user, created_at: 2.days.ago)
      post2 = create(:post, user: followed_user, created_at: 1.day.ago)

      get "/api/v1/feed", params: { page: 1 }

      json = JSON.parse(response.body)

      expect(json.first["created_at"])
        .to be > json.last["created_at"]
    end
  end
end
