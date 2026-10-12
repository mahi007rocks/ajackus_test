require "rails_helper"

RSpec.describe "Events", type: :request do
  describe "GET /" do
    it "renders the events listing page successfully" do
      event = create(:event, title: "Outdoor Concert")

      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Outdoor Concert")
    end
  end

  describe "GET /events/:id" do
    it "renders the event detail page" do
      event = create(:event, title: "Art Exhibition", description: "Modern art collection")

      get event_path(event)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Art Exhibition")
      expect(response.body).to include("Modern art collection")
    end
  end
end
