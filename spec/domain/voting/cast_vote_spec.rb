require "rails_helper"

RSpec.describe Voting::Commands::CastVote do
  let(:event) { create(:event) }
  let(:user_id) { "user_test_123" }

  it "publishes EventUpvoted and updates VoteCount score" do
    expect {
      described_class.call(event_id: event.id, user_id: user_id, vote_type: :upvote)
    }.to change { event.reload.current_score }.by(1)

    vote_count = VoteCount.find_by(event_id: event.id)
    expect(vote_count.upvotes_count).to eq(1)
    expect(vote_count.score).to eq(1)
  end

  it "publishes EventDownvoted and decrements VoteCount score" do
    expect {
      described_class.call(event_id: event.id, user_id: user_id, vote_type: :downvote)
    }.to change { event.reload.current_score }.by(-1)

    vote_count = VoteCount.find_by(event_id: event.id)
    expect(vote_count.downvotes_count).to eq(1)
    expect(vote_count.score).to eq(-1)
  end

  it "raises ValidationError when user_id is blank" do
    expect {
      described_class.call(event_id: event.id, user_id: nil, vote_type: :upvote)
    }.to raise_error(Voting::Commands::CastVote::ValidationError)
  end
end
