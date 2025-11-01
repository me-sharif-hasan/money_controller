import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/expense_goal_provider.dart';
import '../../providers/setting_provider.dart';
import '../../widgets/app_input_field.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../models/expense_goal_model.dart';
import 'package:intl/intl.dart';

class ExpenseGoalPage extends StatefulWidget {
  const ExpenseGoalPage({super.key});

  @override
  State<ExpenseGoalPage> createState() => _ExpenseGoalPageState();
}

class _ExpenseGoalPageState extends State<ExpenseGoalPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showAddGoalDialog() {
    _titleController.clear();
    _amountController.clear();
    _selectedDate = DateTime.now().add(const Duration(days: 7));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(addExpenseGoal),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppInputField(
                  label: goalTitle,
                  controller: _titleController,
                  prefixIcon: Icons.title,
                ),
                const SizedBox(height: 16),
                AppInputField(
                  label: targetAmount,
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.money,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text(targetDate),
                  subtitle: Text(
                    _selectedDate != null
                        ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                        : 'Select Date',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text.trim();
                final amount = double.tryParse(_amountController.text);

                if (title.isNotEmpty && amount != null && amount > 0 && _selectedDate != null) {
                  final goal = ExpenseGoalModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                    amount: amount,
                    targetDate: _selectedDate!,
                    createdAt: DateTime.now(),
                  );

                  await context.read<ExpenseGoalProvider>().addGoal(goal);
                  if(!context.mounted) return;
                  Navigator.pop(context);
                }
              },
              child: const Text(add),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditGoalDialog(ExpenseGoalModel goal) {
    _titleController.text = goal.title;
    _amountController.text = goal.amount.toStringAsFixed(2);
    _selectedDate = goal.targetDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(editExpenseGoal),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppInputField(
                  label: goalTitle,
                  controller: _titleController,
                  prefixIcon: Icons.title,
                ),
                const SizedBox(height: 16),
                AppInputField(
                  label: targetAmount,
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.money,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text(targetDate),
                  subtitle: Text(
                    _selectedDate != null
                        ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                        : 'Select Date',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text.trim();
                final amount = double.tryParse(_amountController.text);

                if (title.isNotEmpty && amount != null && amount > 0 && _selectedDate != null) {
                  final updatedGoal = goal.copyWith(
                    title: title,
                    amount: amount,
                    targetDate: _selectedDate,
                  );

                  await context.read<ExpenseGoalProvider>().updateGoal(updatedGoal);
                  if(!context.mounted) return;
                  Navigator.pop(context);
                }
              },
              child: const Text(update),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String goalId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(delete),
        content: const Text('Are you sure you want to delete this goal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: dangerColor),
            onPressed: () async {
              await context.read<ExpenseGoalProvider>().deleteGoal(goalId);
              if(!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text(delete),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(ExpenseGoalModel goal, String currencySymbol) {
    final daysUntil = goal.daysUntilTarget;
    final isOverdue = goal.isOverdue;
    final isCompleted = goal.isCompleted;

    Color statusColor = primaryColor;
    if (isCompleted) {
      statusColor = successColor;
    } else if (isOverdue) {
      statusColor = dangerColor;
    } else if (daysUntil <= 3) {
      statusColor = warningColor;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    goal.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditGoalDialog(goal);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(goal.id);
                    } else if (value == 'complete') {
                      context.read<ExpenseGoalProvider>().markAsCompleted(goal.id);
                    }
                  },
                  itemBuilder: (context) => [
                    if (!isCompleted)
                      const PopupMenuItem(
                        value: 'complete',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, size: 20, color: successColor),
                            SizedBox(width: 8),
                            Text('Mark Complete'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text(edit),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: dangerColor),
                          SizedBox(width: 8),
                          Text(delete),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Target: $currencySymbol ${goal.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${DateFormat('MMM dd, yyyy').format(goal.targetDate)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha((0.1*255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isCompleted
                        ? completed
                        : isOverdue
                            ? overdue
                            : '$daysUntil days',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (!isCompleted) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha((0.05*255).round()),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withAlpha((0.2*255).round())),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dailyRequirement,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$currencySymbol ${goal.dailyRequirement.toStringAsFixed(2)}/day',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.trending_down,
                      color: statusColor,
                      size: 32,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final goalProvider = context.watch<ExpenseGoalProvider>();
    final settingProvider = context.watch<SettingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(expenseGoals),
      ),
      body: goalProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (goalProvider.activeGoals.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: primaryColor.withAlpha((0.1*255).round()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Daily Requirement',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey[700],
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${settingProvider.currencySymbol} ${goalProvider.totalDailyRequirement.toStringAsFixed(2)}/day',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.savings,
                          size: 48,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: goalProvider.goals.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.flag,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No expense goals yet',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add a goal to save for future expenses',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[500],
                                    ),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            if (goalProvider.activeGoals.isNotEmpty) ...[
                              Text(
                                'Active Goals',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              ...goalProvider.activeGoals.map(
                                (goal) => _buildGoalCard(goal, settingProvider.currencySymbol),
                              ),
                            ],
                            if (goalProvider.completedGoals.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text(
                                'Completed Goals',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: successColor,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              ...goalProvider.completedGoals.map(
                                (goal) => _buildGoalCard(goal, settingProvider.currencySymbol),
                              ),
                            ],
                            if (goalProvider.overdueGoals.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text(
                                'Overdue Goals',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: dangerColor,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              ...goalProvider.overdueGoals.map(
                                (goal) => _buildGoalCard(goal, settingProvider.currencySymbol),
                              ),
                            ],
                          ],
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGoalDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Goal'),
      ),
    );
  }
}

