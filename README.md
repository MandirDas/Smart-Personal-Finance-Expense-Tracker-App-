# Smart Personal Finance & Expense Tracker

## Pre- Requirements
- **Flutter Version** : 3.27.0
- **Dart Version** : 3.6.0
- **Kotlin Version** : 1.8.22
- **Java Version** : temurin-19.0.2
- **Gradle Version** : 8.3
- **AGP Version** : 8.1.0

## 📱 Features

### Core Features
- ✅ **Dashboard with Analytics**
  - Current balance display (total income - total expenses)
  - Recent transactions list (last 10 transactions)
  - Bar chart showing expenses by category for current month
  - Responsive design for portrait and landscape orientations

- ✅ **Transaction Management**
  - Add, edit, and delete transactions
  - Support for both income and expenses
  - Categorization (Food, Travel, Bills, Entertainment, etc.)
  - Date selection and optional descriptions
  - Input validation with user-friendly error messages
  - Swipe-to-delete with confirmation dialog

- ✅ **Budget Tracking**
  - Set monthly budgets per category
  - Visual budget overview with progress bars
  - Color-coded alerts:
    - 🟢 Green: < 80% of budget (Safe)
    - 🟡 Yellow: 80-100% of budget (Warning)
    - 🔴 Red: > 100% of budget (Exceeded)
  - Automatic budget status updates

### Bonus Features
- 🌓 **Light/Dark Mode**
  - Theme toggle in drawer menu
  - Persistent theme preference stored in SQLite
  - Smooth theme transitions

- 📊 **CSV Export**
  - Export all transactions to CSV format
  - Share exported file via native share sheet
  - Includes date, amount, category, description, and type

- ✨ **Smooth Animations**
  - Animated bar charts
  - Smooth screen transitions
  - Material Design 3 components

## 🏗️ Architecture

### Project Structure
```
lib/
├── blocs/                    # State Management (BLoC Pattern)
│   ├── budget/              # Budget-related BLoC
│   │   ├── budget_bloc.dart
│   │   ├── budget_event.dart
│   │   └── budget_state.dart
│   ├── transaction/         # Transaction-related BLoC
│   │   ├── transaction_bloc.dart
│   │   ├── transaction_event.dart
│   │   └── transaction_state.dart
│   └── theme/               # Theme management BLoC
│       ├── theme_bloc.dart
│       ├── theme_event.dart
│       └── theme_state.dart
├── models/                   # Data Models
│   ├── budget_model.dart
│   └── transaction_model.dart
├── screens/                  # UI Screens
│   ├── dashboard_screen.dart
│   ├── transactions_screen.dart
│   ├── add_transaction_screen.dart
│   ├── budgets_screen.dart
│   └── add_budget_screen.dart
├── services/                 # Business Logic & Data Services
│   ├── database_helper.dart
│   └── export_service.dart
├── utils/                    # Utilities & Helpers
│   ├── constants.dart
│   └── helpers.dart
├── widgets/                  # Reusable UI Components
│   ├── balance_card.dart
│   ├── expense_chart.dart
│   └── transaction_list_item.dart
└── main.dart                 # App Entry Point

test/
├── blocs/                    # BLoC Tests
│   └── transaction_bloc_test.dart
├── models/                   # Model Tests
│   ├── budget_model_test.dart
│   └── transaction_model_test.dart
├── utils/                    # Helper Tests
│   └── helpers_test.dart
└── widgets/                  # Widget Tests
    └── balance_card_test.dart
```

### State Management: BLoC Pattern

This app uses the **BLoC (Business Logic Component)** pattern for state management, providing:
- **Separation of Concerns**: Business logic is completely separated from UI
- **Testability**: Easy to write unit tests for business logic
- **Scalability**: Clean architecture that scales well with app complexity
- **Predictability**: Unidirectional data flow makes state changes predictable

#### Why BLoC?
1. **Industry Standard**: Widely used in production Flutter apps
2. **Reactive Programming**: Leverages streams and reactive patterns
3. **Type Safety**: Strongly typed events and states
4. **Debugging**: Easy to trace state changes with BLoC observer
5. **Modularity**: Each feature has its own BLoC for better organization

### Data Persistence: SQLite

**Offline-first** approach using SQLite for local data storage:
- All features work without internet connection
- Fast, efficient database operations
- Proper indexing for optimized queries
- ACID compliance for data integrity

#### Database Schema

**Transactions Table**
```sql
CREATE TABLE transactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  amount REAL NOT NULL,
  category TEXT NOT NULL,
  date TEXT NOT NULL,
  description TEXT NOT NULL,
  isIncome INTEGER NOT NULL
)
```

**Budgets Table**
```sql
CREATE TABLE budgets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  category TEXT NOT NULL,
  budgetAmount REAL NOT NULL,
  month TEXT NOT NULL,
  UNIQUE(category, month)
)
```

**Settings Table** (for theme persistence)
```sql
CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
)
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.4.3 or higher
- Dart SDK 3.x or higher
- Android Studio / VS Code with Flutter extensions
- iOS development: Xcode (for iOS builds)
- Android development: Android SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/MandirDas/Smart-Personal-Finance-Expense-Tracker-App-.git
   cd finance_tracker_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For Android/iOS
   flutter run
   
   # For specific device
   flutter run -d <device-id>
   
   # For release build
   flutter run --release
   ```

### Building for Production

**Android (APK)**
```bash
flutter build apk --release
```

**Android (App Bundle)**
```bash
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/blocs/transaction_bloc_test.dart
```

### Test Coverage

The app includes comprehensive testing:

- ✅ **Unit Tests**: Models, BLoCs, and utility functions
- ✅ **Widget Tests**: UI components
- ✅ **Integration Tests**: Complete user flows (coming soon)

**Tested Components:**
- Transaction CRUD operations
- Budget calculations and alert levels
- Input validation helpers
- Date and currency formatting
- BLoC state transitions
- Widget rendering and interactions

**Coverage Goals:**
- Critical business logic: 90%+
- Overall codebase: 80%+

## 📦 Dependencies

### Core Dependencies
- **flutter_bloc** (^8.1.3): State management
- **equatable** (^2.0.5): Value equality
- **sqflite** (^2.3.0): SQLite database
- **path_provider** (^2.1.1): File system paths
- **fl_chart** (^0.66.0): Charts and graphs
- **intl** (^0.19.0): Internationalization and formatting
- **share_plus** (^7.2.1): Share functionality
- **csv** (^6.0.0): CSV export

### Dev Dependencies
- **flutter_test**: Testing framework
- **flutter_lints** (^3.0.0): Linting rules
- **bloc_test** (^9.1.5): BLoC testing utilities
- **mocktail** (^1.0.1): Mocking library

## 🎨 Design Principles

### Material Design 3
- Modern, adaptive UI components
- Consistent color schemes
- Smooth animations and transitions
- Accessible design patterns

### Responsive Design
- Adapts to different screen sizes
- Landscape and portrait support
- Proper use of MediaQuery and LayoutBuilder

### Code Quality
- Flutter lints enabled
- Consistent naming conventions
- Comprehensive documentation
- Error handling and validation

## 📝 Git Commit History

The project follows **Conventional Commits** for clear history:

```bash
# View commit history
git log --oneline

# Example commits:
# feat: implement SQLite database and models
# feat: setup Bloc for state management
# feat: create dashboard screen with chart and UI
# feat: add CSV export and enhanced features
# test: add comprehensive unit and widget tests
```

## 🔐 Security & Privacy

- All data stored locally on device
- No external API calls or data transmission
- No user authentication required
- Complete offline functionality

## 🐛 Known Issues & Future Enhancements

### Planned Features
- [ ] Recurring transactions
- [ ] Multiple currency support
- [ ] Data backup and restore
- [ ] Biometric authentication
- [ ] Advanced analytics and reports
- [ ] Custom categories
- [ ] Search and filter transactions

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Mandir Das**
- GitHub: [@MandirDas](https://github.com/MandirDas)
- Repository: [Smart-Personal-Finance-Expense-Tracker-App-](https://github.com/MandirDas/Smart-Personal-Finance-Expense-Tracker-App-)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Community packages contributors
- Material Design guidelines

## 📞 Support

For issues, questions, or contributions:
1. Open an issue on GitHub
2. Submit a pull request
3. Contact via GitHub profile

---

**Built with ❤️ using Flutter**
