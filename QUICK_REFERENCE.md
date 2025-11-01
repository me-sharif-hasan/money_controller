# Quick Reference Guide - New Features

## 🎯 Tutorial System (First-Time Users)

### What happens on first launch?
1. Wait 500ms after app loads
2. Tutorial overlay appears automatically
3. Follow 6 guided steps to learn the app
4. Skip anytime or complete all steps

### Tutorial Steps:
1. **Total Money** - Your available funds
2. **Daily Allowance** - How much you can spend today
3. **Remaining Balance** - Money left for today
4. **Add Money** - How to add income
5. **Add Expense** - How to track spending
6. **Menu** - Access all features

### Controls:
- **Next** → Go to next step
- **Skip Tutorial** → Exit immediately
- **Got it!** → Appears on last step

### Won't show again after:
- ✅ Completing all steps
- ✅ Clicking "Skip Tutorial"

---

## 📊 Reports Page

### Access:
**Home → Menu Drawer → Reports**

### 4 Report Types:

#### 1. Daily Tab
- Shows: Today's expenses
- Groups: By day
- Displays: Date with weekday (e.g., "2025-11-01 (Fri)")

#### 2. Weekly Tab
- Shows: Current week (Monday-Sunday)
- Groups: By week
- Displays: Week range (e.g., "2025-10-28 to 2025-11-03")

#### 3. Monthly Tab
- Shows: Current month
- Groups: By month
- Displays: Month and year (e.g., "2025-11 (November 2025)")

#### 4. Custom Tab
- Shows: Any date range you choose
- Steps:
  1. Tap "Start Date" → Pick date
  2. Tap "End Date" → Pick date
  3. Tap "Apply" or just switch tabs
  4. View results

### What Each Report Shows:

#### Total Card (Top)
- 💰 Total expenses in period
- 🧾 Number of transactions
- 📊 Gradient card with shadow

#### Category Breakdown
- 📈 Amount per category
- 📉 Percentage of total
- 🎯 Sorted by highest spend
- 🔤 Categories: Food, Transport, Shopping, etc.

#### Time Period List
- 📅 Individual periods (days/weeks/months)
- 💵 Amount spent in each period
- 🔽 Sorted newest to oldest

### Empty States:
- **No Data**: "No expenses found" with inbox icon
- **Custom (before selection)**: "Select start and end dates"
- **Invalid Range**: "Start date must be before end date"

---

## 🔧 Developer Testing

### Reset Tutorial:
```dart
// Method 1: Clear preference
await PrefsHelper.clear(PREF_ONBOARDING_COMPLETED);

// Method 2: Clear all app data
// Android: Settings → Apps → Money Controller → Clear Data

// Method 3: Uninstall & reinstall
```

### Test Reports:
1. Add expenses with different dates
2. Navigate to Reports
3. Check all 4 tabs
4. Verify calculations match
5. Test empty states
6. Test custom date picker

---

## 🎨 UI Elements

### Reports Page:
- **AppBar**: Blue with white tabs
- **Selected Tab**: White icons/text with underline
- **Unselected Tab**: Semi-transparent white
- **Total Card**: Blue gradient with shadow
- **Category Cards**: Grey background with primary color accents
- **Period Cards**: White cards with elevation

### Tutorial Overlay:
- **Background**: Black semi-transparent (54%)
- **Highlight**: Cutout with white border
- **Tutorial Card**: White with rounded corners
- **Progress Bar**: Linear, blue color
- **Arrow**: White, pointing to target
- **Buttons**: 
  - Skip: Grey text
  - Next/Got it: Blue elevated button

---

## 📱 Navigation Map

```
Home Page
├── Drawer Menu
│   ├── Home
│   ├── Fixed Costs
│   ├── Vault
│   ├── Expense Goals
│   ├── 📊 Reports (NEW!)
│   │   ├── Daily Tab
│   │   ├── Weekly Tab
│   │   ├── Monthly Tab
│   │   └── Custom Tab
│   └── Settings
└── (First Launch) → Tutorial Overlay (6 steps)
```

---

## ⚡ Quick Tips

### Reports:
- 💡 Swipe between tabs or tap tab icons
- 💡 Custom dates persist within session
- 💡 Pull to refresh (if implemented later)
- 💡 Currency symbol from Settings

### Tutorial:
- 💡 Only shows once per device
- 💡 Can't accidentally dismiss (must click button)
- 💡 Automatically finds widgets to highlight
- 💡 Adapts to screen size

---

## 🐛 Troubleshooting

### Tutorial Not Showing?
- Already completed once
- Clear app data to reset
- Check `PREF_ONBOARDING_COMPLETED` = false

### Reports Empty?
- No expenses in selected period
- Check date filters
- Verify expenses have valid dates
- Try different time period

### Tab Icons Not Visible?
- ✅ Fixed! Now white on blue background

---

## 📊 Data Flow

### Reports:
```
ExpenseProvider.expenses 
  → Filter by date range
  → Aggregate by period/category
  → Calculate totals & percentages
  → Display in UI
```

### Tutorial:
```
App Launch
  → Check PREF_ONBOARDING_COMPLETED
  → If false: Wait 500ms → Show Tutorial
  → User completes/skips
  → Save PREF_ONBOARDING_COMPLETED = true
  → Never show again
```

---

## 🎯 Key Features Summary

| Feature | Description | Access |
|---------|-------------|--------|
| **Reports** | View expenses by day/week/month | Drawer → Reports |
| **Daily** | Today's spending | Reports → Daily tab |
| **Weekly** | Current week spending | Reports → Weekly tab |
| **Monthly** | Current month spending | Reports → Monthly tab |
| **Custom** | Any date range | Reports → Custom tab |
| **Tutorial** | First-time user guide | Automatic on first launch |
| **Skip** | Exit tutorial anytime | "Skip Tutorial" button |

---

**Need Help?** Check the full documentation:
- `REPORTS_FEATURE.md` - Complete reports guide
- `TUTORIAL_FEATURE.md` - Complete tutorial guide
- `FEATURE_IMPLEMENTATION_SUMMARY.md` - Technical overview

