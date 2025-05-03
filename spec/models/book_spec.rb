require 'rails_helper'

RSpec.describe Book, type: :model do
  subject { build(:book) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:author) }
  it { should validate_presence_of(:genre) }
  it { should validate_presence_of(:isbn) }
  it { should validate_presence_of(:total_copies) }

  it { should validate_uniqueness_of(:isbn) }

  it { should validate_numericality_of(:total_copies).only_integer.is_greater_than(0) }

  describe "#available_for_borrow?" do
    it "returns true if borrowed books are less than total copies" do
      book = create(:book, total_copies: 2)
      create(:borrowing, book: book, returned_at: nil)
      expect(book.available_for_borrow?).to be true
    end

    it "returns false if all copies are borrowed" do
      book = create(:book, total_copies: 1)
      create(:borrowing, book: book, returned_at: nil)
      expect(book.available_for_borrow?).to be false
    end
  end

  describe ".filter" do
    let!(:book1) { create(:book, title: "The Hobbit", author: "J.R.R. Tolkien", genre: "Fantasy") }
    let!(:book2) { create(:book, title: "The Pragmatic Programmer", author: "Andy Hunt", genre: "Programming") }
    let!(:book3) { create(:book, title: "Clean Code", author: "Robert C. Martin", genre: "Programming") }

    it "returns all books when no filters are provided" do
      expect(Book.filter({})).to match_array([ book1, book2, book3 ])
    end

    it "filters by title case-insensitively" do
      expect(Book.filter(title: "hobbit")).to eq([ book1 ])
      expect(Book.filter(title: "THE")).to include(book1, book2)
    end

    it "filters by author case-insensitively" do
      expect(Book.filter(author: "martin")).to eq([ book3 ])
    end

    it "filters by genre case-insensitively" do
      expect(Book.filter(genre: "programming")).to match_array([ book2, book3 ])
    end

    it "filters by multiple fields together" do
      expect(Book.filter(title: "clean", genre: "programming")).to eq([ book3 ])
    end

    it "returns no books if no match is found" do
      expect(Book.filter(title: "nonexistent")).to be_empty
    end
  end
end
