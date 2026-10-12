namespace :events do
  desc "Sync public events from Billetto API"
  task sync: :environment do
    puts "Syncing events from Billetto..."
    synced = Billetto::SyncEvents.call
    puts "Successfully synced #{synced.size} events."
  end
end
