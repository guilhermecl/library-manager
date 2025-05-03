require 'rails_helper'

RSpec.describe "Borrowings", type: :request do
  let(:member) { create(:user, role: "member") }
  let(:librarian) { create(:user, role: "librarian") }
  let(:book) { create(:book, total_copies: 2) }

  before { sign_in member }

  describe "POST /books/:book_id/borrow" do
    context "when borrowing is valid" do
      it "creates a borrowing record (HTML)" do
        expect {
          post book_borrow_path(book)
        }.to change(Borrowing, :count).by(1)

        expect(response).to redirect_to(books_path)
        follow_redirect!
        expect(response.body).to include("Book borrowed successfully")
      end

      it "creates a borrowing record (JSON)" do
        expect {
          post book_borrow_path(book), headers: { "ACCEPT" => "application/json" }
        }.to change(Borrowing, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include("book_id" => book.id)
      end
    end

    context "when the book is already borrowed by the user" do
      before do
        create(:borrowing, user: member, book: book, returned_at: nil)
      end

      it "does not allow duplicate borrow (HTML)" do
        post book_borrow_path(book)
        expect(response).to redirect_to(books_path)
        follow_redirect!
        expect(response.body).to include("already borrowed")
      end

      it "returns error in JSON format" do
        post book_borrow_path(book), headers: { "ACCEPT" => "application/json" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq("error" => "You've already borrowed this book.")
      end
    end
  end

  describe "PATCH /borrowings/:id/return" do
    context "when the member returns their own book" do
      let!(:borrowing) { create(:borrowing, user: member, book: book, returned_at: nil) }

      it "marks the book as returned (HTML)" do
        patch return_borrowing_path(borrowing)
        expect(response).to redirect_to(books_path)
        expect(borrowing.reload.returned_at).not_to be_nil
      end

      it "marks the book as returned (JSON)" do
        patch return_borrowing_path(borrowing), headers: { "ACCEPT" => "application/json" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("returned_at")
      end
    end

    context "when another user (not a librarian) tries to return" do
      let!(:borrowing) { create(:borrowing, user: create(:user), book: book, returned_at: nil) }

      it "returns forbidden (JSON)" do
        patch return_borrowing_path(borrowing), headers: { "ACCEPT" => "application/json" }
        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)).to eq("error" => "Not authorized to return this book.")
      end
    end

    context "when a librarian returns another user's book" do
      let!(:borrowing) { create(:borrowing, user: member, book: book, returned_at: nil) }

      it "allows return" do
        sign_out member
        sign_in librarian
        patch return_borrowing_path(borrowing)
        expect(response).to redirect_to(books_path)
        expect(borrowing.reload.returned_at).not_to be_nil
      end
    end
  end
end
