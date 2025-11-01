# App Tutorial / Onboarding Feature - Documentation

## Overview
An interactive guided tutorial system has been added to help first-time users understand the app's key features. The tutorial uses visual highlights and step-by-step instructions with the ability to skip at any time.

## New Files Created

### 1. `lib/widgets/tutorial_overlay.dart`
Reusable tutorial overlay widget with the following features:
- **TutorialStep**: Data class containing tutorial information
  - `title`: Step title
  - `description`: Detailed explanation
  - `targetKey`: GlobalKey pointing to the widget to highlight
  - `alignment`: Position of the tutorial card
  - `padding`: Optional padding

- **TutorialOverlay**: Main overlay widget that manages the tutorial flow
  - Displays semi-transparent dark overlay
  - Highlights target widgets with a cutout and border
  - Shows progress indicator (e.g., "1/6")
  - "Skip Tutorial" and "Next"/"Got it!" buttons
  - Pointing arrow from card to target widget

- **Visual Components**:
  - `_HolePainter`: Creates the cutout highlight effect
  - `_ArrowPainter`: Draws pointing arrow to target

### 2. Updated `lib/core/constants/keys.dart`
Added new preference key:
```dart
const String PREF_ONBOARDING_COMPLETED = 'onboarding_completed';
```

### 3. Updated `lib/views/home/home_page.dart`
- Added GlobalKeys for tutorial targets:
  - `_totalMoneyKey`: Total money card
  - `_dailyAllowanceKey`: Daily allowance card
  - `_remainingBalanceKey`: Remaining balance card
  - `_addMoneyKey`: Add money button
  - `_addExpenseKey`: Add expense button
  - `_drawerKey`: Menu/drawer icon
  
- Added tutorial state management:
  - `_showTutorial`: Boolean flag
  - `_checkFirstTimeUser()`: Checks if user has completed onboarding
  - `_completeTutorial()`: Marks tutorial as completed
  - `_skipTutorial()`: Allows user to skip tutorial

## Tutorial Steps

### Step 1: Total Money
**Target**: Total money card at the top
**Message**: "This shows your total available money. Long press or tap the edit icon to update it."

### Step 2: Daily Allowance
**Target**: Daily allowance card (left)
**Message**: "This is how much you can spend per day after accounting for fixed costs and savings goals."

### Step 3: Remaining Balance
**Target**: Remaining balance card (right)
**Message**: "This shows how much money you have left for today after your expenses."

### Step 4: Add Money
**Target**: Add Money button
**Message**: "Tap here to add money to your budget when you receive income."

### Step 5: Add Expense
**Target**: Add Expense button
**Message**: "Tap here to record your expenses. Track what you spend to stay within your daily allowance."

### Step 6: Menu & Features
**Target**: Settings/Menu icon in AppBar
**Message**: "Use the menu drawer to access Fixed Costs, Vault (savings), Expense Goals, Reports, and Settings. Explore all features to manage your finances better!"

## How It Works

### First Launch
1. App checks `PREF_ONBOARDING_COMPLETED` preference
2. If `false` or not set, tutorial is triggered after 500ms delay
3. Tutorial overlay displays with Step 1

### During Tutorial
1. User sees highlighted target widget
2. Semi-transparent overlay dims everything else
3. Tutorial card shows:
   - Progress (e.g., "3/6")
   - Title and description
   - "Skip Tutorial" button (left)
   - "Next" button (right, changes to "Got it!" on last step)
4. User can tap "Next" to proceed or "Skip Tutorial" to exit

### Completion
- When user completes all steps or skips:
  - `PREF_ONBOARDING_COMPLETED` is set to `true`
  - Tutorial overlay is removed
  - Tutorial won't show again on subsequent launches

## User Experience Features

### Visual Design
- **Semi-transparent overlay** (black with 54% opacity)
- **White border** around highlighted target widget
- **Rounded corners** for cutout (8px radius)
- **Material Design card** for tutorial content
- **Linear progress bar** showing completion percentage
- **Pointing arrow** from card to target widget
- **Elevation and shadows** for depth

### Positioning Logic
- Tutorial card automatically positions itself:
  - **Below target** if enough space (300px)
  - **Above target** if not enough space below
  - **Centered** as fallback
- Arrow points from card to target widget center

### Interaction
- **Tap "Next"**: Advances to next step
- **Tap "Skip Tutorial"**: Immediately exits and marks as completed
- **Last step**: "Next" button changes to "Got it!"
- Overlay prevents interaction with app during tutorial

## Technical Details

### Dependencies
- `flutter/material.dart` - UI components
- `shared_preferences` (via PrefsHelper) - Persistence
- `provider` - State management for accessing providers

### GlobalKey Usage
Each tutorial target widget is wrapped with a Container having a GlobalKey:
```dart
Container(
  key: _targetKey,
  child: OriginalWidget(...),
)
```

The key allows the tutorial to:
1. Find widget position: `findRenderObject()` → `localToGlobal()`
2. Get widget size: `renderBox.size`
3. Create precise cutout highlight

### Overlay Management
- Uses Flutter's `Overlay` system
- `OverlayEntry` inserted into overlay stack
- Automatically removed when:
  - Tutorial completes
  - User skips
  - Widget disposed

### State Persistence
- Tutorial completion stored in SharedPreferences
- Key: `PREF_ONBOARDING_COMPLETED`
- Value: `bool` (true = completed)
- Check happens in `initState()` of HomePage

## Testing Checklist

- [ ] Tutorial appears on first app launch
- [ ] Tutorial doesn't appear on subsequent launches
- [ ] All 6 steps display correctly
- [ ] Target widgets are properly highlighted
- [ ] Progress indicator updates correctly
- [ ] "Next" button advances steps
- [ ] "Skip Tutorial" exits immediately
- [ ] Last step shows "Got it!" instead of "Next"
- [ ] Tutorial marks as completed after finishing
- [ ] Tutorial marks as completed after skipping
- [ ] Card positions correctly for all screen sizes
- [ ] Arrow points to correct target
- [ ] Cutout matches target widget size
- [ ] Tutorial works on different devices (phone, tablet)

## Resetting Tutorial (For Testing)

To show the tutorial again during development:

1. **Clear app data** (Android Settings → Apps → Money Controller → Clear Data)
2. **Or** manually delete the preference:
   ```dart
   await PrefsHelper.clear(PREF_ONBOARDING_COMPLETED);
   ```
3. **Or** use Flutter DevTools to clear SharedPreferences
4. **Or** uninstall and reinstall the app

## Future Enhancements (Optional)

- [ ] Add animations for step transitions
- [ ] Allow "Previous" button to go back
- [ ] Add tutorial for other pages (Settings, Vault, etc.)
- [ ] Video or GIF demonstrations
- [ ] Localization for multiple languages
- [ ] Tutorial for advanced features
- [ ] "Show Tips" option in settings to replay tutorial
- [ ] Context-sensitive help (show tip when user first visits a page)
- [ ] Interactive elements (require user to tap target to proceed)
- [ ] Celebration animation on completion

## Customization

### Adding New Tutorial Steps
```dart
TutorialStep(
  title: 'Your Feature',
  description: 'Explain what it does...',
  targetKey: _yourFeatureKey, // Add GlobalKey to the widget
),
```

### Styling Tutorial Card
Modify `_TutorialOverlayContent` in `tutorial_overlay.dart`:
- Change colors, fonts, sizes
- Adjust padding and margins
- Customize button styles

### Changing Overlay Dimness
In `_HolePainter`:
```dart
final paint = Paint()
  ..color = Colors.black54 // Change opacity here (54 = 54%)
  ..style = PaintingStyle.fill;
```

## Impact on Existing Features
✅ **No breaking changes** - Tutorial is purely additive:
- Existing functionality unaffected
- Tutorial only appears for first-time users
- Can be skipped immediately
- Uses minimal storage (one boolean flag)
- No performance impact after completion

## Benefits

1. **Better User Onboarding**: New users understand the app quickly
2. **Reduced Confusion**: Key features are explained upfront
3. **Increased Engagement**: Users discover all features
4. **Professional Polish**: Modern apps have onboarding
5. **Lower Support Burden**: Fewer "how do I...?" questions

