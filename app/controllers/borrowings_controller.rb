class BorrowingsController < ApplicationController
  before_action :authenticate_user!

  def create
    book = Book.find(params[:book_id])

    if current_user.borrowings.exists?(book: book, returned_at: nil)
      respond_with_error("You've already borrowed this book.", :unprocessable_entity)
    elsif !book.available_for_borrow?
      respond_with_error("Book is not available.", :unprocessable_entity)
    else
      borrowing = current_user.borrowings.create!(
        book: book,
        borrowed_at: Time.current,
        due_at: 2.weeks.from_now
      )

      respond_to do |format|
        format.html { redirect_to books_path, notice: "Book borrowed successfully." }
        format.json { render json: borrowing, status: :created }
      end
    end
  end

  def return
    borrowing = Borrowing.find(params[:id])
    if authorized_to_return?(borrowing)
      borrowing.update!(returned_at: Time.current)

      respond_to do |format|
        format.html { redirect_to books_path, notice: "Book marked as returned." }
        format.json { render json: borrowing, status: :ok }
      end
    else
      respond_with_error("Not authorized to return this book.", :forbidden)
    end
  end

  private

  def authorized_to_return?(borrowing)
    current_user.librarian? || current_user == borrowing.user
  end

  def respond_with_error(message, status)
    respond_to do |format|
      format.html { redirect_to books_path, alert: message }
      format.json { render json: { error: message }, status: status }
    end
  end
end
