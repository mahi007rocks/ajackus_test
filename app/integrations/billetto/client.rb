module Billetto
  class ApiError < StandardError; end

  class Client
    DEFAULT_BASE_URL = "https://billetto.dk/api/v3".freeze

    def initialize(api_key: ENV["BILLETTO_API_KEY"], api_secret: ENV["BILLETTO_API_SECRET"], base_url: DEFAULT_BASE_URL)
      @api_key = api_key
      @api_secret = api_secret
      @base_url = base_url
    end

    def fetch_public_events(limit: 50)
      response = connection.get("public/events", { limit: limit })

      unless response.success?
        raise ApiError, "Billetto API request failed with status #{response.status}: #{response.body}"
      end

      JSON.parse(response.body)
    rescue Faraday::Error => e
      raise ApiError, "Network error contacting Billetto API: #{e.message}"
    end

    private

    attr_reader :api_key, :api_secret, :base_url

    def connection
      Faraday.new(url: base_url) do |builder|
        builder.headers["Accept"] = "application/json"
        builder.headers["User-Agent"] = "AjackusTest/1.0"

        keypair = [api_key, api_secret].compact.join(":")
        builder.headers["Api-Keypair"] = keypair if keypair.present?

        builder.options.timeout = 10
        builder.options.open_timeout = 5
        builder.adapter Faraday.default_adapter
      end
    end
  end
end
