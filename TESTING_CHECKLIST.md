# Testing Checklist - Smart Daily Budget

## ✅ Core Functionality Testing

### Budget Management
- [ ] Add initial money amount
- [ ] View total money on home screen
- [ ] Add more money mid-month
- [ ] Verify total updates correctly
- [ ] Check daily allowance calculation

### Fixed Costs
- [ ] Add a new fixed cost
- [ ] Edit existing fixed cost
- [ ] Delete a fixed cost
- [ ] Verify total fixed costs updates
- [ ] Check daily allowance recalculates

### Expense Tracking
- [ ] Add an expense
- [ ] Select different categories
- [ ] View today's expenses list
- [ ] Verify expense deducts from total
- [ ] Check total spent today updates

### Vault System
- [ ] Transfer money to vault
- [ ] View vault balance
- [ ] Check transaction history
- [ ] Verify transfer deducts from total
- [ ] Test multiple transfers

### Settings
- [ ] Toggle hard saving mode
- [ ] Change currency symbol
- [ ] Verify currency updates everywhere
- [ ] Change month start day
- [ ] Check settings persist after restart

## 🔄 Data Persistence Testing

### After App Restart
- [ ] Total money persists
- [ ] Fixed costs remain
- [ ] Expenses are saved
- [ ] Vault balance correct
- [ ] Settings unchanged

## 🎨 UI/UX Testing

### Navigation
- [ ] Drawer menu opens/closes
- [ ] Navigate to Fixed Costs
- [ ] Navigate to Vault
- [ ] Navigate to Settings
- [ ] Back button works

### Dialogs
- [ ] Add money dialog shows
- [ ] Add expense dialog shows
- [ ] Transfer to vault dialog shows
- [ ] Edit fixed cost dialog shows
- [ ] All dialogs can be cancelled

### Display
- [ ] Currency symbol displays correctly
- [ ] Amounts formatted properly
- [ ] Cards show correct colors
- [ ] Icons display properly
- [ ] Text is readable

## 🧮 Calculation Testing

### Daily Allowance
Test: Total = 30000, Fixed = 5000, Days = 25
Expected: 1000/day
- [ ] Result correct

### After Expense
Test: Spend 500 on day 1
Expected: Daily allowance adjusts for remaining days
- [ ] Recalculation correct

### After Adding Money
Test: Add 10000 mid-month
Expected: Daily allowance increases
- [ ] Updates correctly

### Vault Transfer
Test: Transfer 1000 to vault
Expected: Deducted from total, allowance adjusts
- [ ] Works correctly

## 🐛 Edge Cases

### Empty States
- [ ] No fixed costs message shows
- [ ] No expenses message shows
- [ ] No vault transactions message shows

### Invalid Input
- [ ] Negative amounts rejected
- [ ] Empty fields rejected
- [ ] Zero amounts handled
- [ ] Very large numbers work

### Last Day of Month
- [ ] Remaining days = 1
- [ ] All money available
- [ ] Calculations still work

### Month Transition
- [ ] Test on last day
- [ ] Test on first day
- [ ] Date utilities work

## 📱 Platform Testing

### Android
- [ ] App installs
- [ ] Runs without crashes
- [ ] SharedPreferences works
- [ ] UI displays correctly
- [ ] Back button works

### Performance
- [ ] App loads quickly
- [ ] No lag when adding items
- [ ] Lists scroll smoothly
- [ ] Dialogs animate properly

## 🔐 Data Integrity

### Multiple Operations
1. [ ] Add money → Add expense → View balance
2. [ ] Add fixed cost → Check allowance → Delete cost
3. [ ] Transfer to vault → Add more money → Check vault
4. [ ] Change settings → Restart → Verify persists
5. [ ] Add many expenses → View today's list

### Calculations Accuracy
- [ ] Total - Fixed = Remaining
- [ ] Remaining / Days = Daily allowance
- [ ] Sum of fixed costs correct
- [ ] Sum of expenses correct
- [ ] Vault balance accurate

## 🎯 User Scenarios

### Scenario 1: New User
1. [ ] Opens app for first time
2. [ ] Adds 50000 initial money
3. [ ] Adds 3 fixed costs (15000 total)
4. [ ] Sees daily allowance calculated
5. [ ] Records first expense

### Scenario 2: Daily User
1. [ ] Opens app
2. [ ] Adds breakfast expense (150)
3. [ ] Adds lunch expense (300)
4. [ ] Checks remaining allowance
5. [ ] Transfers 500 to vault

### Scenario 3: Month End
1. [ ] Views summary
2. [ ] Checks vault savings
3. [ ] Reviews total expenses
4. [ ] Prepares for next month

## 📝 Notes

### Known Issues
- (Document any bugs found)

### Improvements Needed
- (List enhancement ideas)

### Test Results
- Date Tested: __________
- Tester: __________
- Pass/Fail: __________
- Comments: __________

---

**Testing Complete! ✅**

