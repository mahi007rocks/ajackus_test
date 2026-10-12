class VoteCount < ApplicationRecord
  belongs_to :event

  validates :event_id, presence: true, uniqueness: true
  validates :upvotes_count, :downvotes_count, :score, numericality: { only_integer: true }
end
