require "rails_helper"

RSpec.describe "Events and Voting Workflow", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:event) { create(:event, title: "Outdoor Music Gala") }

  it "guards voting for guests and allows voting after authentication" do
    visit root_path
    expect(page).to have_content("Outdoor Music Gala")
    expect(page).to have_css(".vote-score", text: "0")

    find(".btn-upvote").click
    expect(page).to have_content("Please sign in to vote.")

    fill_in "user_id", with: "user_test_browser_1"
    click_button "Sign In"
    expect(page).to have_content("Signed in as user_test_browser_1")

    find(".btn-upvote").click
    expect(page).to have_content("Upvoted successfully!")
    expect(page).to have_css(".vote-score", text: "1")

    click_button "Sign Out"
    expect(page).to have_content("Signed out")
  end
end
