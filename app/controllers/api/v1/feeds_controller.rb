module Api
  module V1
    class FeedsController < ApplicationController
      before_action :authenticate_user!

      def index
        feed_items = FeedItem
          .where(user_id: current_user.id)
          .includes(post: [:user])
          .order(created_at: :desc)
          .page(params[:page])
          .per(10)

        render json: FeedSerializer.new(feed_items).as_json
      end
    end
  end
end
