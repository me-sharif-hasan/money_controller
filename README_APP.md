# Smart Daily Budget

A Flutter-based budget planning app that helps track daily expenses, manage fixed costs, and achieve savings goals.

## Features

- **Budget Management**: Track total money and calculate daily allowance
- **Fixed Costs**: Manage monthly recurring expenses
- **Expense Tracking**: Record daily expenses with categories
- **Vault System**: Save money and track savings progress
- **Settings**: Customize currency, saving mode, and preferences

## Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the app

### Dependencies

- `provider`: State management
- `shared_preferences`: Local data persistence
- `fl_chart`: Data visualization
- `intl`: Date and number formatting

## Project Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/      # App constants (colors, strings, keys)
│   ├── utils/          # Helper utilities
│   └── themes/         # App theme
├── models/             # Data models
├── providers/          # State management
├── views/              # UI screens
└── widgets/            # Reusable widgets
```

## How It Works

1. **Set Total Money**: Enter your available funds for the month
2. **Add Fixed Costs**: Define recurring expenses (rent, bills, etc.)
3. **Daily Allowance**: Automatically calculated based on remaining days
4. **Track Expenses**: Record daily spending
5. **Save to Vault**: Transfer savings to secure vault
6. **Monitor Progress**: View spending patterns and savings growth

## Hard Saving Mode

When enabled, any unused daily allowance automatically transfers to your vault at the end of each day.

## License

This project is for personal use.

