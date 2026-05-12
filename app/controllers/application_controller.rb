class ApplicationController < ActionController::API
  # NOTE: Authentication is bypassed here for demo/testing purposes only.
  # In a production system, this would be handled via a proper auth layer
  # (e.g. JWT, session tokens, or OAuth) and enforced via a before_action.

  def authenticate_user!
    true
  end

  def current_user
    # Demo only: would normally decode token/session to fetch authenticated user
    User.first
  end
end
