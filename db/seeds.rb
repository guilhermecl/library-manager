puts "🌱 Seeding database..."

# Clear existing data (optional)
Borrowing.destroy_all
Book.destroy_all
User.destroy_all

# Create users
puts "👤 Creating users..."

librarian = User.create!(
  email: "librarian@example.com",
  password: "password",
  password_confirmation: "password",
  role: "librarian"
)

members = 5.times.map do |i|
  User.create!(
    email: "member#{i + 1}@example.com",
    password: "password",
    password_confirmation: "password",
    role: "member"
  )
end

# Create books
puts "📚 Creating books..."

books = [
  { title: "Clean Code", author: "Robert C. Martin", genre: "Programming", isbn: "9780132350884", total_copies: 5 },
  { title: "The Pragmatic Programmer", author: "Andy Hunt", genre: "Programming", isbn: "9780201616224", total_copies: 3 },
  { title: "The Hobbit", author: "J.R.R. Tolkien", genre: "Fantasy", isbn: "9780261103344", total_copies: 4 },
  { title: "To Kill a Mockingbird", author: "Harper Lee", genre: "Fiction", isbn: "9780061120084", total_copies: 2 },
  { title: "1984", author: "George Orwell", genre: "Dystopian", isbn: "9780451524935", total_copies: 6 }
].map { |attrs| Book.create!(attrs) }

# Create borrowings
puts "📖 Creating borrowings..."

Borrowing.create!(
  user: members[0],
  book: books[0],
  borrowed_at: 10.days.ago,
  due_at: 4.days.from_now
)

Borrowing.create!(
  user: members[1],
  book: books[1],
  borrowed_at: 20.days.ago,
  due_at: 6.days.ago, # overdue
  returned_at: nil
)

Borrowing.create!(
  user: members[2],
  book: books[2],
  borrowed_at: 15.days.ago,
  due_at: 1.day.ago,
  returned_at: Time.zone.today
)

puts "✅ Done seeding!"
