import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/setting_provider.dart';
import '../../providers/expense_goal_provider.dart';
import '../../widgets/amount_card.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input_field.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../models/expense_model.dart';
import '../fixed_cost/fixed_cost_page.dart';
import '../vault/vault_page.dart';
import '../settings/settings_page.dart';
import '../expense_goal/expense_goal_page.dart';
import '../reports/report_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _addMoneyController = TextEditingController();
  final _expenseAmountController = TextEditingController();
  final _expenseDescriptionController = TextEditingController();
  String _selectedCategory = 'Food';

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Health',
    'Other',
  ];

  @override
  void dispose() {
    _addMoneyController.dispose();
    _expenseAmountController.dispose();
    _expenseDescriptionController.dispose();
    super.dispose();
  }

  void _showAddMoneyDialog() {
    _addMoneyController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(ADD_MONEY),
        content: AppInputField(
          label: AMOUNT,
          controller: _addMoneyController,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.money,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(CANCEL),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(_addMoneyController.text);
              if (amount != null && amount > 0) {
                context.read<BudgetProvider>().addMoney(amount);
                _addMoneyController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text(ADD),
          ),
        ],
      ),
    );
  }

  void _showEditTotalMoneyDialog() {
    final budgetProvider = context.read<BudgetProvider>();
    _addMoneyController.text = budgetProvider.totalMoney.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Total Money'),
        content: AppInputField(
          label: 'Total Amount',
          controller: _addMoneyController,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.edit,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(CANCEL),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(_addMoneyController.text);
              if (amount != null && amount >= 0) {
                context.read<BudgetProvider>().setTotalMoney(amount);
                _addMoneyController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text(SAVE),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog() {
    _expenseAmountController.clear();
    _expenseDescriptionController.clear();
    _selectedCategory = 'Food';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(ADD_EXPENSE),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppInputField(
                label: AMOUNT,
                controller: _expenseAmountController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.money,
              ),
              const SizedBox(height: 16),
              AppInputField(
                label: DESCRIPTION,
                controller: _expenseDescriptionController,
                prefixIcon: Icons.description,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: CATEGORY,
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(CANCEL),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(_expenseAmountController.text);
              if (amount != null && amount > 0) {
                final expense = ExpenseModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  amount: amount,
                  description: _expenseDescriptionController.text,
                  category: _selectedCategory,
                  date: DateTime.now(),
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                await context.read<ExpenseProvider>().addExpense(expense);
                await context.read<BudgetProvider>().deductMoney(amount);
                _expenseAmountController.clear();
                _expenseDescriptionController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text(ADD),
          ),
        ],
      ),
    );
  }

  void _showEditExpenseDialog(ExpenseModel expense) {
    _expenseAmountController.text = expense.amount.toString();
    _expenseDescriptionController.text = expense.description;
    setState(() {
      _selectedCategory = expense.category;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Expense'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppInputField(
                label: AMOUNT,
                controller: _expenseAmountController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.money,
              ),
              const SizedBox(height: 16),
              AppInputField(
                label: DESCRIPTION,
                controller: _expenseDescriptionController,
                prefixIcon: Icons.description,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: CATEGORY,
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(CANCEL),
          ),
          ElevatedButton(
            onPressed: () async {
              final newAmount = double.tryParse(_expenseAmountController.text);
              if (newAmount != null && newAmount > 0) {
                // Calculate the difference
                final difference = newAmount - expense.amount;

                // Update expense
                final updatedExpense = expense.copyWith(
                  amount: newAmount,
                  description: _expenseDescriptionController.text,
                  category: _selectedCategory,
                  updatedAt: DateTime.now(),
                );
                await context.read<ExpenseProvider>().updateExpense(updatedExpense);

                // Adjust total money based on difference
                if (difference > 0) {
                  await context.read<BudgetProvider>().deductMoney(difference);
                } else if (difference < 0) {
                  await context.read<BudgetProvider>().addMoney(difference.abs());
                }

                Navigator.pop(context);
              }
            },
            child: const Text(SAVE),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final budgetProvider = context.watch<BudgetProvider>();
    final expenseProvider = context.watch<ExpenseProvider>();
    final settingProvider = context.watch<SettingProvider>();
    final expenseGoalProvider = context.watch<ExpenseGoalProvider>();

    // Sync expense goal requirement with budget provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (budgetProvider.expenseGoalRequirement != expenseGoalProvider.totalDailyRequirement) {
        budgetProvider.setExpenseGoalRequirement(expenseGoalProvider.totalDailyRequirement);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(APP_NAME),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.account_balance_wallet, size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    APP_NAME,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(HOME),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text(FIXED_COSTS),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FixedCostPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.savings),
              title: const Text(VAULT),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VaultPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text(EXPENSE_GOALS),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExpenseGoalPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Reports'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(SETTINGS),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: budgetProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onLongPress: _showEditTotalMoneyDialog,
                    child: Stack(
                      children: [
                        AmountCard(
                          title: TOTAL_MONEY,
                          amount: budgetProvider.totalMoney,
                          currencySymbol: settingProvider.currencySymbol,
                          color: primaryColor,
                          icon: Icons.account_balance_wallet,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: _showEditTotalMoneyDialog,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AmountCard(
                          title: DAILY_ALLOWANCE,
                          amount: budgetProvider.summary?.dailyAllowance ?? 0,
                          currencySymbol: settingProvider.currencySymbol,
                          color: successColor,
                          icon: Icons.calendar_today,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AmountCard(
                          title: REMAINING_BALANCE,
                          amount: budgetProvider.summary?.remainingBalance ?? 0,
                          currencySymbol: settingProvider.currencySymbol,
                          color: warningColor,
                          icon: Icons.account_balance,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: ADD_MONEY,
                          onPressed: _showAddMoneyDialog,
                          icon: Icons.add,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          text: ADD_EXPENSE,
                          onPressed: _showAddExpenseDialog,
                          backgroundColor: dangerColor,
                          icon: Icons.remove,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Today\'s Expenses',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Spent Today',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            '${settingProvider.currencySymbol} ${expenseProvider.getTotalExpensesForToday().toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: dangerColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (expenseProvider.getExpensesByDate(DateTime.now()).isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(NO_DATA),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: expenseProvider.getExpensesByDate(DateTime.now()).length,
                      itemBuilder: (context, index) {
                        final expense = expenseProvider.getExpensesByDate(DateTime.now())[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: dangerColor.withValues(alpha: 0.1),
                              child: const Icon(Icons.shopping_bag, color: dangerColor),
                            ),
                            title: Text(expense.description),
                            subtitle: Text(expense.category),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${settingProvider.currencySymbol} ${expense.amount.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: dangerColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                PopupMenuButton(
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(width: 8),
                                          Text(EDIT),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: dangerColor),
                                          SizedBox(width: 8),
                                          Text(DELETE, style: TextStyle(color: dangerColor)),
                                        ],
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      _showEditExpenseDialog(expense);
                                    } else if (value == 'delete') {
                                      // Return money back when deleting expense
                                      await context.read<BudgetProvider>().addMoney(expense.amount);
                                      await context.read<ExpenseProvider>().deleteExpense(expense.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
}

