require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  subject { create(:borrowing) }

  # Associations
  it { should belong_to(:user) }
  it { should belong_to(:book) }

  # Validations
  it do
    should validate_uniqueness_of(:book_id)
      .scoped_to(:user_id, :returned_at)
      .with_message("already borrowed and not returned")
  end

  describe "uniqueness validation for active borrowings" do
    let(:user) { create(:user) }
    let(:book) { create(:book) }

    it "does not allow borrowing the same book twice without returning" do
      create(:borrowing, user: user, book: book, returned_at: nil)

      duplicate = Borrowing.new(user: user, book: book, returned_at: nil)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:book_id]).to include("already borrowed and not returned")
    end

    it "allows borrowing the same book again after returning" do
      create(:borrowing, user: user, book: book, returned_at: Time.current)

      second = Borrowing.new(user: user, book: book, returned_at: nil)
      expect(second).to be_valid
    end
  end
end
