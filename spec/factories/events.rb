FactoryBot.define do
  factory :event do
    sequence(:external_id) { |n| "billetto_event_#{n}" }
    title { "Summer Music Festival" }
    description { "Annual outdoor music festival." }
    starts_at { 2.days.from_now }
    ends_at { 3.days.from_now }
    image_url { "https://images.billetto.com/event.jpg" }
    url { "https://billetto.com/e/summer-festival" }
    location { "Copenhagen, Denmark" }
  end
end
