class Book < ApplicationRecord
  scope :by_title,  ->(title)  { where("LOWER(title) LIKE ?",  "%#{title.downcase}%") }
  scope :by_author, ->(author) { where("LOWER(author) LIKE ?", "%#{author.downcase}%") }
  scope :by_genre,  ->(genre)  { where("LOWER(genre) LIKE ?",  "%#{genre.downcase}%") }

  has_many :borrowings
  has_many :borrowers, through: :borrowings, source: :user

  validates :title, :author, :genre, :isbn, :total_copies, presence: true
  validates :isbn, uniqueness: true
  validates :total_copies, numericality: { only_integer: true, greater_than: 0 }

  def available_for_borrow?
    total_copies > current_borrowed_count
  end

  def current_borrowed_count
    borrowings.where(returned_at: nil).count
  end

  def self.filter(params)
    books = all
    books = books.by_title(params[:title])   if params[:title].present?
    books = books.by_author(params[:author]) if params[:author].present?
    books = books.by_genre(params[:genre])   if params[:genre].present?
    books
  end
end
