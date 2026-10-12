class VotesController < ApplicationController
  before_action :require_authentication!

  def upvote
    ::Voting::Commands::CastVote.call(
      event_id: params[:event_id],
      user_id: current_user_id,
      vote_type: :upvote
    )

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Upvoted successfully!" }
      format.turbo_stream { redirect_to root_path, notice: "Upvoted successfully!" }
      format.json { render json: { status: "ok" } }
    end
  end

  def downvote
    ::Voting::Commands::CastVote.call(
      event_id: params[:event_id],
      user_id: current_user_id,
      vote_type: :downvote
    )

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Downvoted successfully!" }
      format.turbo_stream { redirect_to root_path, notice: "Downvoted successfully!" }
      format.json { render json: { status: "ok" } }
    end
  end
end
