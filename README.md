# 📚 Library Manager

A simple library management system built with **Ruby on Rails**. It supports:

- Member and librarian user roles (via Devise)
- Book management (CRUD)
- Borrowing and returning books
- Dashboards for both roles
- Turbo-powered filtering
- Responsive UI with Bootstrap 5

---

## 🚀 Setup Instructions

### 1. Clone the repo

```bash
git clone https://github.com/your-username/library-manager.git
cd library-manager
```

### 2. Install dependencies

```bash
bundle install
yarn install --check-files # if using webpacker (optional)
```

### 3. Setup database

```bash
rails db:create
rails db:migrate
rails db:seed
```

### 4. Run the server

```bash
rails server
```

Visit [http://localhost:3000](http://localhost:3000)

---

## 👥 User Roles

### Librarian
- View global dashboard: total books, due today, overdue members
- Mark books as returned

### Member
- Can borrow books
- Sees own dashboard: borrowed books and due dates

---

## 🔑 Default Seed Users

| Role      | Email                  | Password  |
|-----------|------------------------|-----------|
| Librarian | `librarian@example.com` | `password` |
| Member    | `member1@example.com`   | `password` |

---

## 🧪 Running Tests

```bash
bundle exec rspec
```

Includes:
- Model specs (validations, scopes)
- Request specs (books, borrowings, dashboards)
- View and system specs

## 🧠 Thought Process

This application was built with simplicity, maintainability, and clarity in mind:

- **MVC Separation**: The logic for filtering, borrowing, and returning is isolated in the models and controllers, keeping views clean and maintainable.
- **Role-based Behavior**: Dashboards and permissions are scoped by user roles (`librarian`, `member`) using Devise and simple `if` logic in controllers and views.
- **Turbo and Bootstrap**: Turbo Frames allow partial updates (like filters) without full page reloads, while Bootstrap offers a fast, responsive UI with minimal custom CSS.
- **Testing First**: RSpec, FactoryBot, and Shoulda Matchers are used extensively to enforce correctness through model, request, and view/system specs.

---

## 📄 License

MIT — use it, modify it, share it.
