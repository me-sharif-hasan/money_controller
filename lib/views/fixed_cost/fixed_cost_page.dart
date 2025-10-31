import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/setting_provider.dart';
import '../../widgets/app_input_field.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../models/fixed_cost_model.dart';

class FixedCostPage extends StatefulWidget {
  const FixedCostPage({super.key});

  @override
  State<FixedCostPage> createState() => _FixedCostPageState();
}

class _FixedCostPageState extends State<FixedCostPage> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Rent';

  final List<String> _categories = [
    'Rent',
    'Utilities',
    'Transport',
    'Subscription',
    'Loan',
    'Insurance',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showAddFixedCostDialog() {
    _nameController.clear();
    _amountController.clear();
    _selectedCategory = 'Rent';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Fixed Cost'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppInputField(
                label: 'Name',
                controller: _nameController,
                prefixIcon: Icons.label,
              ),
              const SizedBox(height: 16),
              AppInputField(
                label: AMOUNT,
                controller: _amountController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.money,
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
            onPressed: () {
              final amount = double.tryParse(_amountController.text);
              if (amount != null && amount > 0 && _nameController.text.isNotEmpty) {
                final fixedCost = FixedCostModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  amount: amount,
                  category: _selectedCategory,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                context.read<BudgetProvider>().addFixedCost(fixedCost);
                Navigator.pop(context);
              }
            },
            child: const Text(ADD),
          ),
        ],
      ),
    );
  }

  void _showEditFixedCostDialog(FixedCostModel cost) {
    _nameController.text = cost.name;
    _amountController.text = cost.amount.toString();
    _selectedCategory = cost.category;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Fixed Cost'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppInputField(
                label: 'Name',
                controller: _nameController,
                prefixIcon: Icons.label,
              ),
              const SizedBox(height: 16),
              AppInputField(
                label: AMOUNT,
                controller: _amountController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.money,
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
            onPressed: () {
              final amount = double.tryParse(_amountController.text);
              if (amount != null && amount > 0 && _nameController.text.isNotEmpty) {
                final updatedCost = cost.copyWith(
                  name: _nameController.text,
                  amount: amount,
                  category: _selectedCategory,
                  updatedAt: DateTime.now(),
                );
                context.read<BudgetProvider>().updateFixedCost(updatedCost);
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
    final settingProvider = context.watch<SettingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(FIXED_COSTS),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: primaryColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Fixed Costs',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  '${settingProvider.currencySymbol} ${budgetProvider.getTotalFixedCosts().toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: budgetProvider.fixedCosts.isEmpty
                ? const Center(child: Text(NO_DATA))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: budgetProvider.fixedCosts.length,
                    itemBuilder: (context, index) {
                      final cost = budgetProvider.fixedCosts[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: primaryColor.withOpacity(0.1),
                            child: const Icon(Icons.receipt_long, color: primaryColor),
                          ),
                          title: Text(cost.name),
                          subtitle: Text(cost.category),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${settingProvider.currencySymbol} ${cost.amount.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: primaryColor,
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
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showEditFixedCostDialog(cost);
                                  } else if (value == 'delete') {
                                    context.read<BudgetProvider>().deleteFixedCost(cost.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFixedCostDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

