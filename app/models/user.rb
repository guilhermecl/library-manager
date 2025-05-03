class User < ApplicationRecord
  has_many :borrowings
  has_many :borrowed_books, through: :borrowings, source: :book

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[librarian member].freeze

  validates :role, presence: true, inclusion: { in: ROLES }

  def librarian?
    role == "librarian"
  end

  def member?
    role == "member"
  end
end
