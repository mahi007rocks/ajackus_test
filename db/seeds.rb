puts "Seeding database with Billetto events..."
Billetto::SyncEvents.call
puts "Seeding complete! #{Event.count} events in database."
