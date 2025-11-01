import 'package:flutter/foundation.dart';
import '../core/constants/keys.dart';
import '../core/utils/prefs_helper.dart';
import '../models/expense_model.dart';

class ExpenseProvider with ChangeNotifier {
  List<ExpenseModel> _expenses = [];
  bool _isLoading = false;

  List<ExpenseModel> get expenses => _expenses;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _loadExpenses();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadExpenses() async {
    final list = await PrefsHelper.getList(prefExpenses);
    _expenses = list.map((map) => ExpenseModel.fromMap(map)).toList();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    _expenses.add(expense);
    await _saveExpenses();
    notifyListeners();
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
      await _saveExpenses();
      notifyListeners();
    }
  }

  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
    await _saveExpenses();
    notifyListeners();
  }

  Future<void> _saveExpenses() async {
    final list = _expenses.map((expense) => expense.toMap()).toList();
    await PrefsHelper.saveList(prefExpenses, list);
  }

  List<ExpenseModel> getExpensesByDate(DateTime date) {
    return _expenses.where((e) {
      return e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day;
    }).toList();
  }

  List<ExpenseModel> getExpensesByCategory(String category) {
    return _expenses.where((e) => e.category == category).toList();
  }

  List<ExpenseModel> getExpensesByMonth(int year, int month) {
    return _expenses.where((e) {
      return e.date.year == year && e.date.month == month;
    }).toList();
  }

  double getTotalExpenses() {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double getTotalExpensesForToday() {
    final today = DateTime.now();
    final todayExpenses = getExpensesByDate(today);
    return todayExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double getTotalExpensesForMonth(int year, int month) {
    final monthExpenses = getExpensesByMonth(year, month);
    return monthExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }
}

