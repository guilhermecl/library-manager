class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.librarian?
      @total_books = Book.count
      @total_borrowed = Borrowing.where(returned_at: nil).count
      @due_today = Borrowing.where(due_at: Time.zone.today.all_day, returned_at: nil)

      @overdue_members = User
        .joins(:borrowings)
        .where("borrowings.due_at < ? AND borrowings.returned_at IS NULL", Time.zone.today)
        .distinct
    else
      @my_borrowings = current_user.borrowings.order(due_at: :asc)
    end
  end
end
