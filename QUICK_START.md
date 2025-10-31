# Quick Start Guide - Smart Daily Budget

## 🎯 Getting the App Running

### Step 1: Install Dependencies
Open terminal/command prompt in the project folder and run:
```bash
flutter pub get
```

### Step 2: Run the App
```bash
flutter run
```

## 📱 First Time Setup

### 1. Launch the App
The app will open with an empty home screen.

### 2. Add Initial Money
- Tap the "Add Money" button
- Enter your total available money for the month
- Tap "Add"

### 3. Set Up Fixed Costs
- Open the drawer menu (☰)
- Tap "Fixed Costs"
- Tap the + button
- Add your recurring expenses:
  - Rent
  - Utilities
  - Transport passes
  - Subscriptions
  - etc.

### 4. View Your Daily Allowance
- Go back to Home
- See your calculated daily allowance
- This is: (Total Money - Fixed Costs) ÷ Remaining Days

## 💰 Daily Usage

### Track Expenses
1. On the home screen, tap "Add Expense"
2. Enter the amount
3. Add a description
4. Select a category
5. Tap "Add"

### Save to Vault
1. Open drawer → "Vault"
2. Tap "Transfer to Vault"
3. Enter amount to save
4. Tap "Transfer"

## ⚙️ Settings

### Configure Your Preferences
1. Open drawer → "Settings"
2. Available options:
   - **Hard Saving Mode**: Unused allowance auto-saves
   - **Currency Symbol**: Change ৳ to $, €, etc.
   - **Month Start Day**: Set when your month begins

## 📊 Understanding the Dashboard

### Main Cards
- **Total Money**: Your current available balance
- **Daily Allowance**: How much you can spend per day
- **Remaining Balance**: Money after deducting fixed costs

### Today's Expenses
- Shows all expenses recorded today
- Displays total spent for the day
- Color-coded by category

## 🎓 Tips

1. **Add money mid-month**: Just tap "Add Money" anytime
2. **Edit fixed costs**: Tap the menu (⋮) on any fixed cost
3. **Save regularly**: Use the vault feature for your goals
4. **Hard saving mode**: Enable for automatic savings
5. **Track categories**: Monitor spending patterns

## 🔧 Troubleshooting

### App won't start?
```bash
flutter clean
flutter pub get
flutter run
```

### Data not saving?
- Check storage permissions
- Restart the app

### Need to reset?
- Go to Settings → Clear app data (or uninstall/reinstall)

## 📞 Support

For issues or questions, refer to:
- `copilot_instructions.md` - Technical details
- `DEVELOPMENT_SUMMARY.md` - Architecture overview

---

**Enjoy managing your budget! 💰📊**

