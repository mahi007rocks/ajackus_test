require "rails_helper"

RSpec.describe "Votes", type: :request do
  let(:event) { create(:event) }

  describe "when unauthenticated" do
    it "blocks upvoting and redirects with alert" do
      post event_upvote_path(event)

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Please sign in to vote.")
    end

    it "blocks downvoting and redirects with alert" do
      post event_downvote_path(event)

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Please sign in to vote.")
    end
  end

  describe "when authenticated" do
    let(:auth_headers) { { "X-User-Id" => "user_auth_777" } }

    it "records upvote and redirects with notice" do
      post event_upvote_path(event), headers: auth_headers

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Upvoted successfully!")
      expect(event.reload.current_score).to eq(1)
    end

    it "records downvote and redirects with notice" do
      post event_downvote_path(event), headers: auth_headers

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Downvoted successfully!")
      expect(event.reload.current_score).to eq(-1)
    end
  end
end
