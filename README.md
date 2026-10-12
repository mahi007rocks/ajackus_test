# Billetto Events & Voting

A Rails 8 application that syncs public events from the Billetto API and provides event-driven voting using Rails Event Store (RES) and Clerk authentication.

## Setup

### Requirements
- Ruby 3.3.6
- SQLite3

### Installation

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Setup database:
   ```bash
   bin/rails db:setup
   ```

3. Configure environment variables in `.env`:
   ```bash
   BILLETTO_API_KEY=your_key
   BILLETTO_API_SECRET=your_secret
   CLERK_PUBLISHABLE_KEY=pk_test_...
   CLERK_SECRET_KEY=sk_test_...
   ```

4. Fetch events from Billetto:
   ```bash
   bin/rails events:sync
   ```
   *(Or run `bin/rails db:seed`)*

5. Start the server:
   ```bash
   bin/rails server
   ```
   Open `http://localhost:3000`.

## Running Tests

Run the full RSpec test suite:
```bash
bundle exec rspec
```

The suite covers:
- `spec/models/`: Event validations and scopes.
- `spec/integrations/`: Billetto API client and sync service with WebMock.
- `spec/domain/voting/`: Rails Event Store commands, event publishing, and read model projections.
- `spec/requests/`: Authentication guards for voting endpoints.
- `spec/system/`: End-to-end browser voting and login workflow.

## Architecture Notes

### Event Sourcing & CQRS (Rails Event Store)
Rather than updating a mutable integer column on the events table, voting is handled through domain events:
- **Events**: `Voting::Events::EventUpvoted` and `Voting::Events::EventDownvoted` (subclasses of `RubyEventStore::Event`).
- **Command**: `Voting::Commands::CastVote` publishes to `Event$<event_id>` and links the event to `User$<user_id>`.
- **Read Model**: `Voting::Projections::UpdateVoteCount` subscribes to both events and updates the `vote_counts` projection table inside a database transaction.
- **Introspection**: A read-only `EventStoreEvent` ActiveRecord model is provided to query raw event log records from `bin/rails console`.

### Billetto API Integration
External API logic is isolated under `app/integrations/billetto/`:
- `Billetto::Client`: Faraday HTTP client querying `https://billetto.dk/api/v3/public/events` with the `Api-Keypair` header. Wraps network and HTTP failures in `Billetto::ApiError`.
- `Billetto::SyncEvents`: Idempotent upsert matching records on `external_id`.

### Authentication (Clerk)
- Voting endpoints (`POST /events/:id/upvote`, `POST /events/:id/downvote`) require authentication.
- In production/browser, Clerk session tokens (`__session` cookie / Bearer JWT) are decoded to extract the user ID (`sub`).
- For local development and test automation, `Authentication` also supports a session-based login and request header (`X-User-Id`), avoiding hard external network dependencies during test runs.

## Assumptions
- Ingestion is one-way (Billetto -> local database). Creating events on Billetto's platform is out of scope.
- Event store tables use the standard Rails Event Store schema with SQLite3.
