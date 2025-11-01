import 'package:flutter/foundation.dart';
import '../core/constants/keys.dart';
import '../core/utils/prefs_helper.dart';
import '../models/vault_model.dart';

class VaultProvider with ChangeNotifier {
  VaultModel _vault = VaultModel(balance: 0.0, transactions: []);
  bool _isLoading = false;

  VaultModel get vault => _vault;
  bool get isLoading => _isLoading;
  double get balance => _vault.balance;
  List<VaultTransaction> get transactions => _vault.transactions;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _loadVault();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadVault() async {
    final data = await PrefsHelper.getData(prefVault);
    if (data != null) {
      _vault = VaultModel.fromMap(data);
    }
  }

  Future<void> transferToVault(double amount) async {
    final transaction = VaultTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      date: DateTime.now(),
      type: 'Vault Transfer',
      createdAt: DateTime.now(),
    );

    final updatedTransactions = [..._vault.transactions, transaction];
    _vault = VaultModel(
      balance: _vault.balance + amount,
      transactions: updatedTransactions,
    );

    await _saveVault();
    notifyListeners();
  }

  Future<void> withdrawFromVault(double amount) async {
    if (_vault.balance < amount) return;

    final transaction = VaultTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: -amount,
      date: DateTime.now(),
      type: 'Withdrawal',
      createdAt: DateTime.now(),
    );

    final updatedTransactions = [..._vault.transactions, transaction];
    _vault = VaultModel(
      balance: _vault.balance - amount,
      transactions: updatedTransactions,
    );

    await _saveVault();
    notifyListeners();
  }

  Future<void> _saveVault() async {
    await PrefsHelper.saveData(prefVault, _vault.toMap());
  }

  Future<void> updateVaultBalance(double newBalance) async {
    _vault = VaultModel(
      balance: newBalance,
      transactions: _vault.transactions,
    );
    await _saveVault();
    notifyListeners();
  }

  Future<void> updateTransaction(VaultTransaction updatedTransaction) async {
    final index = _vault.transactions.indexWhere((t) => t.id == updatedTransaction.id);
    if (index == -1) return;

    final oldTransaction = _vault.transactions[index];
    final balanceChange = updatedTransaction.amount - oldTransaction.amount;

    final updatedTransactions = List<VaultTransaction>.from(_vault.transactions);
    updatedTransactions[index] = updatedTransaction;

    _vault = VaultModel(
      balance: _vault.balance + balanceChange,
      transactions: updatedTransactions,
    );

    await _saveVault();
    notifyListeners();
  }

  Future<void> deleteTransaction(String transactionId) async {
    final transaction = _vault.transactions.firstWhere(
      (t) => t.id == transactionId,
      orElse: () => VaultTransaction(
        id: '',
        amount: 0,
        date: DateTime.now(),
        type: '',
        createdAt: DateTime.now(),
      ),
    );

    if (transaction.id.isEmpty) return;

    final updatedTransactions = _vault.transactions.where((t) => t.id != transactionId).toList();

    _vault = VaultModel(
      balance: _vault.balance - transaction.amount,
      transactions: updatedTransactions,
    );

    await _saveVault();
    notifyListeners();
  }

  List<VaultTransaction> getTransactionsByMonth(int year, int month) {
    return _vault.transactions.where((t) {
      return t.date.year == year && t.date.month == month;
    }).toList();
  }
}

