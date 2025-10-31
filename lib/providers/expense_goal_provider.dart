import 'package:flutter/foundation.dart';
import '../core/constants/keys.dart';
import '../core/utils/prefs_helper.dart';
import '../models/expense_goal_model.dart';

class ExpenseGoalProvider with ChangeNotifier {
  List<ExpenseGoalModel> _goals = [];
  bool _isLoading = false;

  List<ExpenseGoalModel> get goals => _goals;
  bool get isLoading => _isLoading;

  List<ExpenseGoalModel> get activeGoals =>
      _goals.where((g) => !g.isCompleted && !g.isOverdue).toList();

  List<ExpenseGoalModel> get completedGoals =>
      _goals.where((g) => g.isCompleted).toList();

  List<ExpenseGoalModel> get overdueGoals =>
      _goals.where((g) => g.isOverdue).toList();

  double get totalDailyRequirement {
    return activeGoals.fold(0.0, (sum, goal) => sum + goal.dailyRequirement);
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _loadGoals();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadGoals() async {
    final list = await PrefsHelper.getList(PREF_EXPENSE_GOALS);
    _goals = list.map((map) => ExpenseGoalModel.fromMap(map)).toList();
  }

  Future<void> _saveGoals() async {
    final list = _goals.map((goal) => goal.toMap()).toList();
    await PrefsHelper.saveList(PREF_EXPENSE_GOALS, list);
  }

  Future<void> addGoal(ExpenseGoalModel goal) async {
    _goals.add(goal);
    await _saveGoals();
    notifyListeners();
  }

  Future<void> updateGoal(ExpenseGoalModel goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      await _saveGoals();
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String id) async {
    _goals.removeWhere((g) => g.id == id);
    await _saveGoals();
    notifyListeners();
  }

  Future<void> markAsCompleted(String id) async {
    final index = _goals.indexWhere((g) => g.id == id);
    if (index != -1) {
      _goals[index] = _goals[index].copyWith(isCompleted: true);
      await _saveGoals();
      notifyListeners();
    }
  }

  Future<void> addSavedAmount(String id, double amount) async {
    final index = _goals.indexWhere((g) => g.id == id);
    if (index != -1) {
      final currentSaved = _goals[index].savedAmount;
      _goals[index] = _goals[index].copyWith(savedAmount: currentSaved + amount);

      if (_goals[index].savedAmount >= _goals[index].amount) {
        _goals[index] = _goals[index].copyWith(isCompleted: true);
      }

      await _saveGoals();
      notifyListeners();
    }
  }

  ExpenseGoalModel? getGoalById(String id) {
    try {
      return _goals.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }

  List<ExpenseGoalModel> getGoalsByDateRange(DateTime start, DateTime end) {
    return _goals.where((g) {
      return g.targetDate.isAfter(start) && g.targetDate.isBefore(end);
    }).toList();
  }
}

