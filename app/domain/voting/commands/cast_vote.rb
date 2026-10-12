module Voting
  module Commands
    class CastVote
      class ValidationError < StandardError; end

      def self.call(event_id:, user_id:, vote_type:, event_store: Rails.configuration.event_store)
        new(event_id: event_id, user_id: user_id, vote_type: vote_type, event_store: event_store).call
      end

      def initialize(event_id:, user_id:, vote_type:, event_store: Rails.configuration.event_store)
        @event_id = event_id.to_s
        @user_id = user_id.to_s
        @vote_type = vote_type.to_sym
        @event_store = event_store
      end

      def call
        validate!

        event = build_event
        stream_name = "Event$#{event_id}"

        event_store.publish(
          event,
          stream_name: stream_name
        )

        event_store.link(
          event.event_id,
          stream_name: "User$#{user_id}"
        )

        event
      end

      private

      attr_reader :event_id, :user_id, :vote_type, :event_store

      def validate!
        raise ValidationError, "Event ID cannot be blank" if event_id.blank?
        raise ValidationError, "User ID cannot be blank" if user_id.blank?
        raise ValidationError, "Invalid vote type" unless %i[upvote downvote].include?(vote_type)
      end

      def build_event
        data = { event_id: event_id, user_id: user_id }

        if vote_type == :upvote
          Voting::Events::EventUpvoted.new(data: data)
        else
          Voting::Events::EventDownvoted.new(data: data)
        end
      end
    end
  end
end
