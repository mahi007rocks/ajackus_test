class EventStoreEvent < ApplicationRecord
  self.table_name = "event_store_events"
  self.primary_key = "id"

  def readonly?
    true
  end
end
