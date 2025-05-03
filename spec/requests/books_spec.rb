require 'rails_helper'

RSpec.describe "/books", type: :request do
  let(:user) { create(:user) }
  before { sign_in user }

  let(:valid_attributes) do
    {
      title: "Effective Testing",
      author: "My Author",
      genre: "Non-fiction",
      isbn: "1234567890",
      total_copies: 3
    }
  end

  let(:invalid_attributes) do
    {
      title: "",
      author: "",
      genre: "",
      isbn: nil,
      total_copies: -1
    }
  end

  let(:new_attributes) do
    {
      title: "Refactored Title"
    }
  end

  describe "GET /index" do
    it "renders a successful response" do
      Book.create!(valid_attributes)
      get books_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      book = Book.create!(valid_attributes)
      get book_url(book)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_book_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      book = Book.create!(valid_attributes)
      get edit_book_url(book)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Book" do
        expect {
          post books_url, params: { book: valid_attributes }
        }.to change(Book, :count).by(1)
      end

      it "redirects to the created book" do
        post books_url, params: { book: valid_attributes }
        expect(response).to redirect_to(book_url(Book.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Book" do
        expect {
          post books_url, params: { book: invalid_attributes }
        }.not_to change(Book, :count)
      end

      it "renders unprocessable_entity on failure" do
        post books_url, params: { book: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested book" do
        book = Book.create!(valid_attributes)
        patch book_url(book), params: { book: new_attributes }
        book.reload
        expect(book.title).to eq("Refactored Title")
      end

      it "redirects to the book" do
        book = Book.create!(valid_attributes)
        patch book_url(book), params: { book: new_attributes }
        expect(response).to redirect_to(book_url(book))
      end
    end

    context "with invalid parameters" do
      it "renders unprocessable_entity" do
        book = Book.create!(valid_attributes)
        patch book_url(book), params: { book: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested book" do
      book = Book.create!(valid_attributes)
      expect {
        delete book_url(book)
      }.to change(Book, :count).by(-1)
    end

    it "redirects to the books list" do
      book = Book.create!(valid_attributes)
      delete book_url(book)
      expect(response).to redirect_to(books_url)
    end
  end
end
