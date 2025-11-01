import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vault_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/setting_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input_field.dart';
import '../../widgets/amount_card.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import 'package:intl/intl.dart';

class VaultPage extends StatefulWidget {
  const VaultPage({super.key});

  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  final _transferController = TextEditingController();
  final _withdrawController = TextEditingController();
  final _balanceController = TextEditingController();
  final _editAmountController = TextEditingController();
  final _editTypeController = TextEditingController();
  
  late final _readCtx=context.read;
  late final _navigatorContext=Navigator.of(context);

  @override
  void dispose() {
    _transferController.dispose();
    _withdrawController.dispose();
    _balanceController.dispose();
    _editAmountController.dispose();
    _editTypeController.dispose();
    super.dispose();
  }

  void _showTransferDialog() {
    _transferController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(transferToVault),
        content: AppInputField(
          label: amount,
          controller: _transferController,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.savings,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(_transferController.text);
              var readCtx = _readCtx;
              if (amount != null && amount > 0) {
                await readCtx<VaultProvider>().transferToVault(amount);
                await readCtx<BudgetProvider>().deductMoney(amount);
                _navigatorContext.pop();
              }
            },
            child: const Text('Transfer'),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog() {
    _withdrawController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(withdraw),
        content: AppInputField(
          label: amount,
          controller: _withdrawController,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.arrow_upward,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(_withdrawController.text);
              if (amount != null && amount > 0) {
                await _readCtx<VaultProvider>().withdrawFromVault(amount);
                await _readCtx<BudgetProvider>().addMoney(amount);
                _navigatorContext.pop();
              }
            },
            child: const Text(withdraw),
          ),
        ],
      ),
    );
  }

  void _showUpdateBalanceDialog() {
    final vaultProvider = _readCtx<VaultProvider>();
    final currentBalance = vaultProvider.balance;
    _balanceController.text = currentBalance.toStringAsFixed(2);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(updateBalance),
        content: AppInputField(
          label: 'New Balance',
          controller: _balanceController,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.account_balance_wallet,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final newBalance = double.tryParse(_balanceController.text);
              if (newBalance != null && newBalance >= 0) {
                final balanceChange = newBalance - currentBalance;

                // Update vault balance
                await _readCtx<VaultProvider>().updateVaultBalance(newBalance);

                // Sync with budget: if vault increased, budget should decrease
                if (balanceChange != 0) {
                  await _readCtx<BudgetProvider>().deductMoney(balanceChange);
                }

                _navigatorContext.pop();
              }
            },
            child: const Text(update),
          ),
        ],
      ),
    );
  }

  void _showEditTransactionDialog(transaction) {
    _editAmountController.text = transaction.amount.abs().toStringAsFixed(2);
    _editTypeController.text = transaction.type;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(editTransaction),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppInputField(
              label: amount,
              controller: _editAmountController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.money,
            ),
            const SizedBox(height: 16),
            AppInputField(
              label: 'Type',
              controller: _editTypeController,
              prefixIcon: Icons.category,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(_editAmountController.text);
              final type = _editTypeController.text.trim();
              if (amount != null && amount > 0 && type.isNotEmpty) {
                final isPositive = transaction.amount > 0;
                final newAmount = isPositive ? amount : -amount;
                final oldAmount = transaction.amount;
                final balanceChange = newAmount - oldAmount;

                final updatedTransaction = transaction.copyWith(
                  amount: newAmount,
                  type: type,
                );

                // Update vault transaction
                await _readCtx<VaultProvider>().updateTransaction(updatedTransaction);

                // Sync with budget: if vault balance increased, budget should decrease
                if (balanceChange != 0) {
                  await _readCtx<BudgetProvider>().deductMoney(balanceChange);
                }

                _navigatorContext.pop();
              }
            },
            child: const Text(update),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String transactionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(delete),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: dangerColor),
            onPressed: () async {
              final vaultProvider = _readCtx<VaultProvider>();

              // Find the transaction to get its amount before deleting
              final transaction = vaultProvider.transactions.firstWhere(
                (t) => t.id == transactionId,
                orElse: () => throw Exception('Transaction not found'),
              );

              // Delete from vault
              await vaultProvider.deleteTransaction(transactionId);

              // Return money to budget: if vault decreased, budget should increase
              await _readCtx<BudgetProvider>().addMoney(transaction.amount);

              _navigatorContext.pop();
            },
            child: const Text(delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vaultProvider = context.watch<VaultProvider>();
    final settingProvider = context.watch<SettingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(vault),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'update_balance') {
                _showUpdateBalanceDialog();
              } else if (value == 'withdraw') {
                _showWithdrawDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'update_balance',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text(updateBalance),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'withdraw',
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward),
                    SizedBox(width: 8),
                    Text(withdraw),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: successColor.withAlpha((0.1*255).round()),
            child: Column(
              children: [
                AmountCard(
                  title: vaultBalance,
                  amount: vaultProvider.balance,
                  currencySymbol: settingProvider.currencySymbol,
                  color: successColor,
                  icon: Icons.savings,
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: transferToVault,
                  onPressed: _showTransferDialog,
                  backgroundColor: successColor,
                  icon: Icons.arrow_downward,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transactions,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: vaultProvider.transactions.isEmpty
                ? const Center(child: Text(noData))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: vaultProvider.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = vaultProvider.transactions.reversed.toList()[index];
                      final isPositive = transaction.amount > 0;
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: (isPositive ? successColor : dangerColor).withAlpha((0.1*255).round()),
                            child: Icon(
                              isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                              color: isPositive ? successColor : dangerColor,
                            ),
                          ),
                          title: Text(transaction.type),
                          subtitle: Text(DateFormat('MMM dd, yyyy').format(transaction.date)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${isPositive ? '+' : ''}${settingProvider.currencySymbol} ${transaction.amount.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: isPositive ? successColor : dangerColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showEditTransactionDialog(transaction);
                                  } else if (value == 'delete') {
                                    _showDeleteConfirmation(transaction.id);
                                  }
                                },
                                itemBuilder: (context) => [
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
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

