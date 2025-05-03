FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "Book Title #{n}" }
    author { "Author Name" }
    genre { "Fiction" }
    sequence(:isbn) { |n| "ISBN#{n}" }
    total_copies { 3 }
  end
end
