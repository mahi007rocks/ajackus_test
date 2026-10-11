require "rails_helper"

RSpec.describe Event, type: :model do
  describe "validations" do
    subject { build(:event) }

    it { is_expected.to be_valid }

    it "requires a title" do
      event = build(:event, title: nil)
      expect(event).not_to be_valid
      expect(event.errors[:title]).to include("can't be blank")
    end

    it "requires an external_id" do
      event = build(:event, external_id: nil)
      expect(event).not_to be_valid
      expect(event.errors[:external_id]).to include("can't be blank")
    end

    it "enforces unique external_id" do
      create(:event, external_id: "billetto_unique_1")
      duplicate = build(:event, external_id: "billetto_unique_1")

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:external_id]).to include("has already been taken")
    end

    it "requires starts_at" do
      event = build(:event, starts_at: nil)
      expect(event).not_to be_valid
      expect(event.errors[:starts_at]).to include("can't be blank")
    end
  end

  describe "scopes" do
    describe ".upcoming" do
      it "orders events chronologically by start date" do
        event_later = create(:event, starts_at: 5.days.from_now)
        event_sooner = create(:event, starts_at: 1.day.from_now)

        expect(described_class.upcoming).to eq([event_sooner, event_later])
      end
    end
  end
end
