module Voting
  module Projections
    class UpdateVoteCount
      def call(event)
        event_id = event.data.fetch(:event_id)

        ApplicationRecord.transaction do
          record = VoteCount.lock.find_or_initialize_by(event_id: event_id)

          case event
          when Voting::Events::EventUpvoted
            record.upvotes_count += 1
          when Voting::Events::EventDownvoted
            record.downvotes_count += 1
          end

          record.score = record.upvotes_count - record.downvotes_count
          record.save!
        end
      end
    end
  end
end
