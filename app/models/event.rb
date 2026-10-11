class Event < ApplicationRecord
  validates :external_id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :starts_at, presence: true

  scope :upcoming, -> { order(starts_at: :asc) }
end
