module Billetto
  class SyncEvents
    def self.call(client: Client.new)
      new(client: client).call
    end

    def initialize(client: Client.new)
      @client = client
    end

    def call
      raw_data = client.fetch_public_events
      records = extract_events_list(raw_data)

      records.map do |item|
        upsert_event(item)
      end.compact
    end

    private

    attr_reader :client

    def extract_events_list(data)
      if data.is_a?(Array)
        data
      elsif data.is_a?(Hash)
        data["data"] || data["events"] || []
      else
        []
      end
    end

    def upsert_event(data)
      external_id = data["id"].to_s
      return if external_id.blank?

      event = Event.find_or_initialize_by(external_id: external_id)
      event.assign_attributes(
        title: data["title"] || data["name"] || "Untitled Event",
        description: data["description"],
        starts_at: parse_datetime(data["startdate"] || data["starts_at"] || data["start_date"] || Time.current),
        ends_at: parse_datetime(data["enddate"] || data["ends_at"] || data["end_date"]),
        image_url: data["image_link"] || data["image_url"] || data.dig("image", "url"),
        url: data["url"] || data["event_url"],
        location: extract_location(data["location"])
      )
      event.save!
      event
    end

    def extract_location(loc)
      return loc if loc.is_a?(String)
      return loc["location_name"] || loc["city"] if loc.is_a?(Hash)
      nil
    end

    def parse_datetime(val)
      return nil if val.blank?
      Time.zone.parse(val.to_s) rescue nil
    end
  end
end
