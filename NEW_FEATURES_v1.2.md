# New Features - Version 1.2

## Overview
This update adds comprehensive vault management and a powerful expense goal feature to help you save for future expenses while managing your daily budget.

## 🆕 New Features

### 1. Enhanced Vault Management

#### **Update Vault Balance**
- Access via menu (⋮) in Vault page → "Update Balance"
- Directly set the vault balance to any amount
- Useful for correcting errors or syncing with actual savings

#### **Withdraw from Vault**
- Access via menu (⋮) in Vault page → "Withdraw"
- Transfer money back from vault to your total money
- Automatically updates both vault and main budget

#### **Edit Vault Transactions**
- Tap menu (⋮) on any transaction → "Edit"
- Modify transaction amount and type
- Balance automatically recalculates

#### **Delete Vault Transactions**
- Tap menu (⋮) on any transaction → "Delete"
- Removes transaction from history
- Balance automatically adjusts

---

### 2. Expense Goals (NEW!)

#### **What is an Expense Goal?**
An expense goal helps you save money for a specific future expense by automatically reducing your daily allowance. This ensures you have the required amount ready when you need it.

#### **Use Case Example**
*"I have a program in 7 days where I need 500 BDT extra"*

**Solution:**
1. Create an Expense Goal:
   - Title: "Program Event"
   - Amount: 500 BDT
   - Target Date: 7 days from today

2. The app will:
   - Calculate daily requirement: 500 ÷ 7 = 71.43 BDT/day
   - Reduce your daily allowance by 71.43 BDT for the next 7 days
   - After 7 days, your allowance returns to normal
   - You'll have saved 500 BDT for your program!

#### **How to Use Expense Goals**

**Access:**
- Open drawer menu → "Expense Goals"

**Create a Goal:**
1. Tap the floating "Add Goal" button
2. Enter:
   - **Goal Title**: Name of the expense (e.g., "New Phone", "Trip", "Program")
   - **Target Amount**: How much you need to save
   - **Target Date**: When you need the money
3. Tap "Add"

**View Goals:**
- **Active Goals**: Currently saving towards
- **Completed Goals**: Goals you've achieved
- **Overdue Goals**: Passed target date without completion

**Goal Information Shows:**
- Days remaining until target date
- Daily requirement amount (how much less you'll have per day)
- Total daily requirement (sum of all active goals)

**Manage Goals:**
- **Edit**: Tap menu (⋮) → "Edit" to modify title, amount, or date
- **Mark Complete**: Tap menu (⋮) → "Mark Complete" when goal is achieved
- **Delete**: Tap menu (⋮) → "Delete" to remove goal

---

### 3. Smart Daily Allowance Calculation

#### **How it Works:**

**Without Expense Goals:**
```
Daily Allowance = (Total Money - Fixed Costs) ÷ Remaining Days
```

**With Expense Goals:**
```
Daily Allowance = (Total Money - Fixed Costs) ÷ Remaining Days - Goal Requirements
```

#### **Example Calculation:**

**Scenario:**
- Total Money: 10,000 BDT
- Fixed Costs: 3,000 BDT
- Remaining Days: 20 days
- Expense Goal: 500 BDT in 7 days

**Calculation:**
1. Base Allowance: (10,000 - 3,000) ÷ 20 = 350 BDT/day
2. Goal Requirement: 500 ÷ 7 = 71.43 BDT/day
3. **Adjusted Allowance: 350 - 71.43 = 278.57 BDT/day**

**Result:**
- For the next 7 days: Spend only 278.57 BDT/day
- After 7 days: Spend full 350 BDT/day again
- You'll have 500 BDT saved for your goal!

---

## 📱 User Interface Updates

### Vault Page
- New toolbar menu with "Update Balance" and "Withdraw" options
- Transaction cards now have action menus for edit and delete
- Enhanced transaction display with better visual feedback

### Expense Goals Page (NEW!)
- Clean, card-based layout showing all goals
- Color-coded status indicators:
  - 🔵 Blue: Normal active goals
  - 🟡 Yellow: Urgent (3 days or less)
  - 🟢 Green: Completed
  - 🔴 Red: Overdue
- Real-time daily requirement calculator
- Total daily requirement summary at top

### Home Page
- New "Expense Goals" menu item in drawer
- Daily allowance automatically adjusts for active goals
- Seamless integration with existing budget system

---

## 🎯 Benefits

1. **Better Planning**: Save for future expenses without manually calculating daily budgets
2. **Automatic Adjustments**: Daily allowance adjusts automatically based on goals
3. **Multiple Goals**: Create multiple expense goals simultaneously
4. **Time-Based**: Goals only affect allowance until target date
5. **Visual Tracking**: See progress and requirements at a glance
6. **Flexible Management**: Edit, complete, or delete goals anytime

---

## 🔧 Technical Details

### New Models
- `ExpenseGoalModel`: Stores goal information and calculates requirements
- Enhanced `VaultModel`: Supports balance updates and transaction editing

### New Providers
- `ExpenseGoalProvider`: Manages expense goals state and persistence

### Enhanced Providers
- `BudgetProvider`: Now considers expense goals in allowance calculation
- `VaultProvider`: Added update, edit, and delete functionality

---

## 📋 Quick Start Guide

### Create Your First Expense Goal

1. **Open the app** and tap menu (☰)
2. **Select "Expense Goals"**
3. **Tap the "Add Goal" button**
4. **Fill in details:**
   ```
   Title: Weekend Trip
   Amount: 1000
   Target Date: [Select date 10 days ahead]
   ```
5. **Tap "Add"**
6. **Return to home** - Your daily allowance is now reduced by 100 BDT/day
7. **After 10 days** - Your allowance returns to normal, and you have 1000 BDT saved!

### Update Vault Balance

1. **Go to Vault page**
2. **Tap menu (⋮) at top right**
3. **Select "Update Balance"**
4. **Enter new balance amount**
5. **Tap "Update"**

### Edit a Transaction

1. **Go to Vault page**
2. **Find the transaction** you want to edit
3. **Tap menu (⋮) on the transaction**
4. **Select "Edit"**
5. **Update amount or type**
6. **Tap "Update"**

---

## ⚠️ Important Notes

1. **Goal Timing**: Expense goals only reduce allowance for the days until the target date
2. **Multiple Goals**: If you have multiple goals, their daily requirements are added together
3. **Completed Goals**: Mark goals as complete when achieved to stop affecting your allowance
4. **Overdue Goals**: Goals that pass their target date are marked overdue but still tracked
5. **Vault Edits**: Editing vault transactions recalculates the balance automatically

---

## 🐛 Known Limitations

- Expense goals don't automatically transfer money to vault (manual transfer required)
- Goals calculate based on calendar days, not remaining period days
- Once a goal is overdue, its daily requirement no longer affects allowance

---

## 💡 Tips & Best Practices

1. **Plan Ahead**: Create expense goals as soon as you know about future expenses
2. **Regular Review**: Check your expense goals page weekly
3. **Mark Complete**: Always mark goals as complete when achieved
4. **Buffer Time**: Add 1-2 extra days to your goal period for safety
5. **Combine Features**: Use expense goals for saving, then transfer to vault for security

---

## 🔄 Version History

**v1.2.0** - October 31, 2025
- ✅ Added expense goals feature
- ✅ Enhanced vault management (update, edit, delete)
- ✅ Integrated goals with daily allowance calculation
- ✅ New expense goals page with comprehensive UI
- ✅ Smart daily requirement calculator

---

**Need Help?** Review the examples above or check the in-app help section.
o