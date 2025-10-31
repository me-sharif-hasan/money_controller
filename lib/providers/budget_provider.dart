import 'package:flutter/foundation.dart';
import '../core/constants/keys.dart';
import '../core/utils/prefs_helper.dart';
import '../models/fixed_cost_model.dart';
import '../models/budget_summary_model.dart';
import '../core/utils/calculation.dart';
import '../core/utils/date_utils.dart' as app_date;

class BudgetProvider with ChangeNotifier {
  double _totalMoney = 0.0;
  List<FixedCostModel> _fixedCosts = [];
  BudgetSummaryModel? _summary;
  bool _isLoading = false;
  int _monthStartDay = 1;
  int _monthEndDay = 31;
  double _expenseGoalRequirement = 0.0;

  double get totalMoney => _totalMoney;
  List<FixedCostModel> get fixedCosts => _fixedCosts;
  BudgetSummaryModel? get summary => _summary;
  bool get isLoading => _isLoading;
  double get expenseGoalRequirement => _expenseGoalRequirement;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _loadSettings();
    await _loadTotalMoney();
    await _loadFixedCosts();
    await _calculateSummary();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    final data = await PrefsHelper.getData(PREF_SETTINGS);
    if (data != null) {
      _monthStartDay = data['monthStartDay'] as int? ?? 1;
      _monthEndDay = data['monthEndDay'] as int? ?? 31;
    }
  }

  Future<void> _loadTotalMoney() async {
    final money = await PrefsHelper.getDouble(PREF_TOTAL_MONEY);
    _totalMoney = money ?? 0.0;
  }

  Future<void> _loadFixedCosts() async {
    final list = await PrefsHelper.getList(PREF_FIXED_COSTS);
    _fixedCosts = list.map((map) => FixedCostModel.fromMap(map)).toList();
  }

  Future<void> setTotalMoney(double amount) async {
    _totalMoney = amount;
    await PrefsHelper.saveDouble(PREF_TOTAL_MONEY, amount);
    await _calculateSummary();
    notifyListeners();
  }

  Future<void> addMoney(double amount) async {
    _totalMoney += amount;
    await PrefsHelper.saveDouble(PREF_TOTAL_MONEY, _totalMoney);
    await _calculateSummary();
    notifyListeners();
  }

  Future<void> deductMoney(double amount) async {
    _totalMoney -= amount;
    await PrefsHelper.saveDouble(PREF_TOTAL_MONEY, _totalMoney);
    await _calculateSummary();
    notifyListeners();
  }

  Future<void> addFixedCost(FixedCostModel cost) async {
    _fixedCosts.add(cost);
    await _saveFixedCosts();
    await _calculateSummary();
    notifyListeners();
  }

  Future<void> updateFixedCost(FixedCostModel cost) async {
    final index = _fixedCosts.indexWhere((c) => c.id == cost.id);
    if (index != -1) {
      _fixedCosts[index] = cost;
      await _saveFixedCosts();
      await _calculateSummary();
      notifyListeners();
    }
  }

  Future<void> deleteFixedCost(String id) async {
    _fixedCosts.removeWhere((c) => c.id == id);
    await _saveFixedCosts();
    await _calculateSummary();
    notifyListeners();
  }

  Future<void> _saveFixedCosts() async {
    final list = _fixedCosts.map((cost) => cost.toMap()).toList();
    await PrefsHelper.saveList(PREF_FIXED_COSTS, list);
  }

  void setExpenseGoalRequirement(double requirement) {
    _expenseGoalRequirement = requirement;
    _calculateSummary();
    notifyListeners();
  }

  Future<void> _calculateSummary({int? startDay, int? endDay}) async {
    final now = DateTime.now();
    final useStartDay = startDay ?? _monthStartDay;
    final useEndDay = endDay ?? _monthEndDay;

    final remainingDays = app_date.getRemainingDaysWithCustomPeriod(now, useStartDay, useEndDay);
    final totalFixed = calculateTotalFixedCosts(_fixedCosts.map((c) => c.toMap()).toList());
    final remaining = _totalMoney - totalFixed;
    final daily = calculateDailyAllowanceWithGoals(_totalMoney, totalFixed, remainingDays, _expenseGoalRequirement);

    _summary = BudgetSummaryModel(
      totalMoney: _totalMoney,
      totalFixedCosts: totalFixed,
      remainingBalance: remaining,
      dailyAllowance: daily,
      remainingDays: remainingDays,
      calculatedAt: now,
    );
  }

  Future<void> recalculateWithCustomPeriod(int startDay, int endDay) async {
    _monthStartDay = startDay;
    _monthEndDay = endDay;
    await _calculateSummary(startDay: startDay, endDay: endDay);
    notifyListeners();
  }

  double getTotalFixedCosts() {
    return _fixedCosts.fold(0.0, (sum, cost) => sum + cost.amount);
  }
}

