# 🧭 GitHub Copilot Instruction Guide for Budget Planning App

## 📌 Project Overview

**App Name:** Money Controller
**Framework:** Flutter (Dart)
**Local Storage:** SharedPreferences (Android-optimized key–value storage)
**Future Plan:** Firebase integration (Firestore-style structure retained in logic)

**Purpose:**

* Manage and visualize daily and monthly budget.
* Deduct fixed costs from total money.
* Support adding money mid-month.
* Provide savings goal tracking.
* Include Vault feature for savings management.
* Handle flexible vs. hard saving logic.
* Store all data locally using **SharedPreferences**.

---

## 🎯 Functional Goals

1. **Fixed Cost Management**

    * Add/edit/remove fixed costs such as rent, transport, utilities.
    * Data persisted in SharedPreferences under key `"fixed_costs"`.
    * Allows dynamic custom cost entries.

2. **Budget Calculation**

    * `remaining_balance = total_money - total_fixed_costs`
    * `daily_allowance = remaining_balance / remaining_days`
    * Recalculated automatically whenever:

        * Money is added.
        * Expense or vault transfer is made.
        * New day begins.
    * Carryover rules:

        * **Flexible mode:** unused allowance carries forward.
        * **Hard saving mode:** unused amount goes to Vault (as saved).

3. **Add Money Mid-Month**

    * Add funds anytime.
    * Updates total available balance.
    * Recalculates future allowances.
    * Logged in `"transactions"` list in SharedPreferences.

4. **Vault Feature**

    * Vault holds savings transferred from daily allowance.
    * User can transfer from allowance to vault:

        * Deducts from today’s allowance.
        * Treated as an expense entry.
        * Updates vault total.
    * Vault page shows balance and transaction history.
    * Stored under key `"vault_data"`.

5. **Savings Goal**

    * User defines a monthly saving goal.
    * The system calculates daily saving requirement.
    * Progress measured using Vault balance.
    * Stored under `"saving_goal"` key.

6. **Visualization**

    * Graphs show:

        * Minimum (target) vs. Actual expenses.
        * Vault growth and goal completion.
    * Warning indicator if trending toward debt.

---

## 🧱 Code Architecture

### Folder Structure

```
lib/
 ├── main.dart
 ├── core/
 │    ├── constants/
 │    │    ├── colors.dart
 │    │    ├── strings.dart
 │    │    └── keys.dart
 │    ├── utils/
 │    │    ├── prefs_helper.dart
 │    │    ├── date_utils.dart
 │    │    └── calculation.dart
 │    └── themes/
 │         └── app_theme.dart
 ├── models/
 │    ├── expense_model.dart
 │    ├── fixed_cost_model.dart
 │    ├── budget_summary_model.dart
 │    ├── vault_model.dart
 │    └── saving_goal_model.dart
 ├── providers/
 │    ├── budget_provider.dart
 │    ├── expense_provider.dart
 │    ├── vault_provider.dart
 │    └── setting_provider.dart
 ├── views/
 │    ├── home/
 │    │    ├── home_page.dart
 │    │    └── usage_graph.dart
 │    ├── fixed_cost/
 │    │    └── fixed_cost_page.dart
 │    ├── vault/
 │    │    └── vault_page.dart
 │    ├── saving_goal/
 │    │    └── saving_goal_page.dart
 │    └── settings/
 │         └── settings_page.dart
 ├── widgets/
 │    ├── app_button.dart
 │    ├── app_input_field.dart
 │    ├── graph_card.dart
 │    ├── info_tile.dart
 │    └── amount_card.dart
```

---

## 🧩 Copilot Coding Rules

### 1. **General Code Rules**

* Clean, null-safe Dart.
* No comments unless requested.
* Use `const` and `final`.
* Follow **MVVM + Provider** pattern.
* Immutable data models with `copyWith`, `toMap`, `fromMap`.
* All persistence through `PrefsHelper` utility.
* Business logic never mixed with UI.

### 2. **PrefsHelper Utility**

File: `core/utils/prefs_helper.dart`
Copilot must implement reusable async methods:

```dart
Future<void> saveData(String key, Map<String, dynamic> data);
Future<Map<String, dynamic>?> getData(String key);
Future<void> saveList(String key, List<Map<String, dynamic>> list);
Future<List<Map<String, dynamic>>> getList(String key);
Future<void> clear(String key);
```

Internally uses `SharedPreferences` JSON-encoded strings.

### 3. **Providers**

* Use `ChangeNotifier`.
* Call PrefsHelper for persistence.
* Notify listeners after successful data save.
* BudgetProvider handles allowance and money addition logic.
* VaultProvider handles vault transfers, updates, and history.
* ExpenseProvider manages daily expenses and category filtering.
* SettingProvider manages app preferences.

### 4. **Vault Logic**

* Transfers from allowance:

    * Create an expense record (`type = "Vault Transfer"`).
    * Update vault total.
    * If hard saving mode = off → treat remaining allowance as carry-forward.
* Vault data format:

  ```json
  {
    "balance": 2500,
    "transactions": [
      {"id": "v1", "amount": 500, "date": "2025-10-12"}
    ]
  }
  ```

### 5. **Storage Keys**

All keys centralized in `core/constants/keys.dart`:

```dart
const PREF_TOTAL_MONEY = 'total_money';
const PREF_FIXED_COSTS = 'fixed_costs';
const PREF_EXPENSES = 'expenses';
const PREF_VAULT = 'vault_data';
const PREF_SETTINGS = 'settings';
const PREF_GOAL = 'saving_goal';
```

### 6. **Calculation Methods**

In `core/utils/calculation.dart`:

* `calculateDailyAllowance(double total, double fixed, int remainingDays)`
* `calculateSavingNeed(double goal, int remainingDays)`
* `adjustAllowance(double spent, double allowance, bool flexible)`
* `recalculateAfterAddition(double added, int remainingDays)`
* `vaultTransferImpact(double transfer, bool flexibleMode)`

### 7. **UI Rules**

* Use `Consumer` or `Selector` from Provider.
* Reuse widgets.
* Always fetch and update via provider.
* VaultPage shows:

    * Current balance.
    * Transaction list.
    * Transfer option.

### 8. **Visualization**

* Use `fl_chart`.
* Two datasets: minimum vs actual.
* Warning color if projected debt.

### 9. **Settings**

* Stored under `PREF_SETTINGS`:

  ```json
  {
    "hardSavingMode": false,
    "currencySymbol": "৳",
    "monthStartDay": 1
  }
  ```
* Exposed through `SettingProvider`.

---

## 🧠 Copilot Workflow

1. Implement `PrefsHelper` first.
2. Implement models → `toMap()` and `fromMap()`.
3. Create providers using `PrefsHelper` for persistence.
4. Build `BudgetProvider` logic for total, allowance, addition, recalculation.
5. Integrate all providers in `main.dart` using `MultiProvider`.
6. Build responsive UI with linked providers.

---

## 🧪 Firebase Preparation

All models include:

* `id`, `createdAt`, `updatedAt`.
* Stub methods:

    * `fromFirestore(Map<String, dynamic> doc)`
    * `toFirestore()`

---

## 🧰 Allowed Packages

* `provider`
* `shared_preferences`
* `fl_chart`
* `intl`

---

## 📈 Naming Convention

| Type     | Convention       | Example                   |
| -------- | ---------------- | ------------------------- |
| Model    | PascalCase       | `VaultModel`              |
| Provider | PascalCase       | `VaultProvider`           |
| Widget   | PascalCase       | `VaultPage`, `UsageGraph` |
| File     | snake_case       | `vault_provider.dart`     |
| Variable | camelCase        | `dailyAllowance`          |
| Constant | UPPER_SNAKE_CASE | `PREF_VAULT`              |

---

## 🧹 Clean Code Rules

* No inline JSON parsing in providers or views.
* No `setState`, use Providers.
* No print statements.
* No global mutable state.
* Keep widget files concise (<150 lines).
* Reuse constants for all keys, strings, and colors.

---

## 🛑 Forbidden

* Writing directly to SharedPreferences outside PrefsHelper.
* Inline JSON encode/decode calls.
* Logic in UI.
* Duplicated calculation functions.

---

## 🔒 Final Directive

> GitHub Copilot must **strictly follow this document** for every file and completion in this repository.
> All persistence must use `SharedPreferences` through `PrefsHelper`.
> No deviation is allowed unless explicitly overridden by Master Sharif.
