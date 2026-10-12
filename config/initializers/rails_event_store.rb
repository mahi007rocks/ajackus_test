require "rails_event_store"
require "aggregate_root"

Rails.configuration.to_prepare do
  event_store = RailsEventStore::JSONClient.new
  Rails.configuration.event_store = event_store

  event_store.subscribe(
    Voting::Projections::UpdateVoteCount.new,
    to: [
      Voting::Events::EventUpvoted,
      Voting::Events::EventDownvoted
    ]
  )
end
