require "rails_helper"
require "webmock/rspec"

RSpec.describe Billetto::Client do
  let(:client) { described_class.new(api_key: "my_key", api_secret: "my_secret", base_url: "https://billetto.dk/api/v3") }

  it "fetches and parses events successfully" do
    stub_request(:get, "https://billetto.dk/api/v3/public/events?limit=50")
      .with(headers: { "Api-Keypair" => "my_key:my_secret" })
      .to_return(status: 200, body: { "data" => [{ "id" => "001", "title" => "Tech Summit" }] }.to_json)

    result = client.fetch_public_events
    expect(result["data"]).to eq([{ "id" => "001", "title" => "Tech Summit" }])
  end

  it "raises ApiError on failed response" do
    stub_request(:get, "https://billetto.dk/api/v3/public/events?limit=50")
      .to_return(status: 500, body: "Server Error")

    expect { client.fetch_public_events }.to raise_error(Billetto::ApiError)
  end
end
