module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user_id, :user_signed_in?
  end

  def current_user_id
    @current_user_id ||= resolve_user_id
  end

  def user_signed_in?
    current_user_id.present?
  end

  def require_authentication!
    return if user_signed_in?

    respond_to do |format|
      format.html { redirect_to root_path, alert: "Please sign in to vote." }
      format.json { render json: { error: "Authentication required" }, status: :unauthorized }
    end
  end

  private

  def resolve_user_id
    header_user_id = request.headers["X-User-Id"]
    return header_user_id if header_user_id.present?

    session_user_id = session[:user_id]
    return session_user_id if session_user_id.present?

    clerk_token = request.cookies["__session"] || bearer_token
    return nil if clerk_token.blank?

    extract_user_id_from_clerk_token(clerk_token)
  end

  def bearer_token
    auth_header = request.headers["Authorization"]
    return nil if auth_header.blank?

    auth_header.split(" ").last if auth_header.start_with?("Bearer ")
  end

  def extract_user_id_from_clerk_token(token)
    decoded = JWT.decode(token, nil, false).first
    decoded["sub"]
  rescue StandardError
    nil
  end
end
