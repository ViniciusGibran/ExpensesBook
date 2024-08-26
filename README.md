# Expenses Book 📚

A SwiftUI app for tracking and categorizing expenses. Allows users to quickly capture receipts, input expense details, and view them. The app is designed to work offline with local data storage using Realm.

## Features
- **Receipt Capture**: Capture receipts using your camera or select images from the gallery.
- **Expense Categorization**: Categorize expenses and manage categories with customizable labels and colors.
- **Monthly Overview**: View expenses grouped by month for easy and intuitive tracking.
- **Offline Functionality**: Works seamlessly offline, with all data persisted locally using Realm.
- **Category Management**: Manage categories with options to add custom categories.
- **Error Handling and Feedback**: Responsive error handling and user feedback throughout the app using the MVVM architecture.

## Tech Stack
- **SwiftUI**: For building a declarative and responsive user interface.
- **Realm**: For local data storage and offline-first capability with an easy-to-use, flexible database.
- **VisionKit**: Currently used to scan a expense receipt image. (Planned for OCR text extraction - currently on the TODO list).
- **MVVM Architecture**: Ensuring a clean separation of logic, UI, and data management.
- **XCTest**: Covers Realm ModelsDTO CRUD transactions and Respositories logics.

## Project Structure
- `Common/`: Shared utilities, extensions, and components used across the app.
- `Models/`: Data models (e.g., `Expense`, `Category`) represented as Realm DTOs and Structs for clean MVVM separation.
- `ViewModels/`: Business logic and data management, adhering to the MVVM architecture.
- `Views/`: SwiftUI views that make up the app’s user interface.
- `Repositories/`: Data handling layer managing CRUD operations, integrating Realm and DTO conversions.
- `Tests/`: Unit tests and integration tests using XCTest, ensuring the reliability of business logic and UI workflows.


## TODO: Future Improvements
- **OCR Integration**: Implement Optical Character Recognition (OCR) using VisionKit to automatically extract text details from receipts.
- **Searchable Expense List**: Add a search bar to filter expenses by name, category, or date.
- **iCloud Sync**: Enable syncing expenses across multiple devices using iCloud.
- **Data Export/Import**: Allow users to export expenses as CSV or JSON and import backups.
- **Custom Notifications**: Add reminder notifications for expense logging or category thresholds.
- **Dark Mode Enhancements**: Fine-tune UI for better dark mode support.
- **In-App Purchase Integration**: Introduce premium features for advanced users.
- **Localization**: Add support for multiple languages.
- **Advanced Filtering**: Implement complex filters (e.g., date ranges, specific categories).
- **UI/UX Enhancements**: Improve overall user experience based on feedback and A/B testing.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
