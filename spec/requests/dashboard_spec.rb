require "rails_helper"

RSpec.describe "Dashboards", type: :request do
  let!(:book) { create(:book, total_copies: 3) }

  describe "GET /dashboard as a librarian" do
    let(:librarian) { create(:user, role: "librarian") }

    before do
      # Create overdue and due-today borrowings
      create(:borrowing, due_at: 1.day.ago, returned_at: nil)                  # overdue
      create(:borrowing, due_at: Time.zone.today.noon, returned_at: nil)      # due today
      create(:borrowing, returned_at: Time.zone.yesterday)                    # returned

      sign_in librarian
      get dashboard_path
    end

    it "renders successfully" do
      expect(response).to have_http_status(:ok)
    end

    it "shows total books count" do
      expect(response.body).to include("Total Books")
      expect(response.body).to include(Book.count.to_s)
    end

    it "includes overdue members" do
      expect(response.body).to include("Overdue")
    end

    it "includes books due today" do
      expect(response.body).to include("Due Today")
    end
  end

  describe "GET /dashboard as a member" do
    let(:member) { create(:user, role: "member") }

    before do
      create(:borrowing, user: member, book: book, due_at: 1.day.from_now)
      sign_in member
      get dashboard_path
    end

    it "renders successfully" do
      expect(response).to have_http_status(:ok)
    end

    it "shows user's borrowed book" do
      expect(response.body).to include(book.title)
    end

    it "does not show librarian metrics" do
      expect(response.body).not_to include("Total Books")
      expect(response.body).not_to include("Overdue")
    end
  end
end
