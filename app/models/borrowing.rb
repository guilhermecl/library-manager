class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :book_id, uniqueness: { scope: [ :user_id, :returned_at ], message: "already borrowed and not returned" }
end
