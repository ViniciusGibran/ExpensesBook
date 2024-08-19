# Expenses Book 📚

A simple SwiftUI app for tracking and categorizing your expenses. **Expenses Book** allows users to quickly capture receipts, input expense details, and view them in a clean and organized way. The app is designed to work offline with local data storage using Realm.

## Features
- Capture receipts with the camera or select from the gallery.
- Automatically extract details from receipts using OCR (VisionKit).
- Categorize expenses and manage categories with custom labels and colors.
- View expenses grouped by month for easy tracking.
- Works seamlessly offline with data persisted locally using Realm.

## Tech Stack
- **SwiftUI**: For building the user interface.
- **Realm**: For local data storage and offline-first functionality.
- **VisionKit**: For OCR text extraction from receipt images.
- **MVVM Architecture**: Ensuring clean separation of logic, UI, and data management.
- **XCTest**: For TDD (Test-Driven Development) with unit and UI tests.

## Project Structure
- `Models/`: Data models (e.g., `Expense`, `Category`) defined with Realm.
- `ViewModels/`: Business logic and data handling in MVVM.
- `Views/`: SwiftUI views for the user interface.
- `Tests/`: Unit and UI tests using XCTest.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
