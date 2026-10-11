require "rails_helper"

RSpec.describe Billetto::SyncEvents do
  let(:fake_client) { instance_double(Billetto::Client) }
  let(:sample_data) do
    [
      {
        "id" => "101",
        "title" => "Tech Conference",
        "description" => "A tech conference",
        "starts_at" => "2026-11-01T10:00:00Z",
        "image_url" => "https://example.com/image.jpg"
      }
    ]
  end

  it "creates new events from api data" do
    allow(fake_client).to receive(:fetch_public_events).and_return(sample_data)

    expect { described_class.call(client: fake_client) }.to change(Event, :count).by(1)

    event = Event.find_by(external_id: "101")
    expect(event.title).to eq("Tech Conference")
    expect(event.image_url).to eq("https://example.com/image.jpg")
  end

  it "updates existing events without creating duplicates" do
    create(:event, external_id: "101", title: "Old Title")
    allow(fake_client).to receive(:fetch_public_events).and_return(sample_data)

    expect { described_class.call(client: fake_client) }.not_to change(Event, :count)
    expect(Event.find_by(external_id: "101").title).to eq("Tech Conference")
  end
end
