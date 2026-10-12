class Event < ApplicationRecord
  has_one :vote_count, dependent: :destroy

  validates :external_id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :starts_at, presence: true

  scope :upcoming, -> { order(starts_at: :asc) }

  def current_score
    vote_count&.score || 0
  end
end
