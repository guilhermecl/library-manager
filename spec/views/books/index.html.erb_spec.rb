require "rails_helper"

RSpec.describe "books/index", type: :view do
  let(:user) { build_stubbed(:user, role: "member") }
  let(:books) do
    [
      build_stubbed(:book, title: "Clean Code", author: "Uncle Bob", genre: "Programming", isbn: "123456", total_copies: 3),
      build_stubbed(:book, title: "The Hobbit", author: "Tolkien", genre: "Fantasy", isbn: "654321", total_copies: 2)
    ]
  end

  before do
    assign(:books, books)
    allow(view).to receive(:current_user).and_return(user)
    allow(user).to receive_message_chain(:borrowings, :exists?).and_return(false)
    render
  end

  it "renders page title and heading" do
    expect(rendered).to include("Books")
    expect(rendered).to have_selector("h1", text: "Books")
  end

  it "renders the New Book button" do
    expect(rendered).to have_link("New Book", href: new_book_path)
  end

  it "renders filter form fields" do
    expect(rendered).to have_selector("form input[name='title']")
    expect(rendered).to have_selector("form input[name='author']")
    expect(rendered).to have_selector("form input[name='genre']")
    expect(rendered).to have_button("Filter")
  end

  it "renders a table of books" do
    books.each do |book|
      expect(rendered).to have_selector("td", text: book.title)
      expect(rendered).to have_selector("td", text: book.author)
      expect(rendered).to have_selector("td", text: book.genre)
      expect(rendered).to have_selector("td", text: book.isbn)
      expect(rendered).to have_selector("td", text: book.total_copies.to_s)
    end
  end

  it "renders action buttons for each book" do
    expect(rendered).to have_link("Show", href: book_path(books.first))
    expect(rendered).to have_link("Edit", href: edit_book_path(books.first))
    expect(rendered).to have_selector("form button", text: "Borrow")
  end
end
