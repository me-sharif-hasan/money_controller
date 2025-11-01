import 'package:intl/intl.dart';
import '../../models/expense_model.dart';

class ReportUtils {
  /// Filter expenses by date range (inclusive)
  static List<ExpenseModel> filterByRange(
    List<ExpenseModel> expenses,
    DateTime start,
    DateTime end,
  ) {
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);

    return expenses.where((expense) {
      final expenseDate = expense.date;
      return expenseDate.isAfter(startDate.subtract(const Duration(milliseconds: 1))) &&
          expenseDate.isBefore(endDate.add(const Duration(milliseconds: 1)));
    }).toList();
  }

  /// Aggregate expenses by day
  static Map<String, double> aggregateByDay(List<ExpenseModel> expenses) {
    final dateFormat = DateFormat('yyyy-MM-dd (EEE)');
    final Map<String, double> aggregated = {};

    for (var expense in expenses) {
      final key = dateFormat.format(expense.date);
      aggregated[key] = (aggregated[key] ?? 0) + expense.amount;
    }

    return _sortMapByKeyDescending(aggregated);
  }

  /// Aggregate expenses by week
  static Map<String, double> aggregateByWeek(List<ExpenseModel> expenses) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final Map<String, double> aggregated = {};

    for (var expense in expenses) {
      final date = expense.date;
      final weekStart = date.subtract(Duration(days: date.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));
      final key = 'Week: ${dateFormat.format(weekStart)} to ${dateFormat.format(weekEnd)}';
      aggregated[key] = (aggregated[key] ?? 0) + expense.amount;
    }

    return _sortMapByKeyDescending(aggregated);
  }

  /// Aggregate expenses by month
  static Map<String, double> aggregateByMonth(List<ExpenseModel> expenses) {
    final dateFormat = DateFormat('yyyy-MM (MMMM yyyy)');
    final Map<String, double> aggregated = {};

    for (var expense in expenses) {
      final key = dateFormat.format(expense.date);
      aggregated[key] = (aggregated[key] ?? 0) + expense.amount;
    }

    return _sortMapByKeyDescending(aggregated);
  }

  /// Aggregate expenses by category for a given list
  static Map<String, double> aggregateByCategory(List<ExpenseModel> expenses) {
    final Map<String, double> aggregated = {};

    for (var expense in expenses) {
      final key = expense.category;
      aggregated[key] = (aggregated[key] ?? 0) + expense.amount;
    }

    // Sort by amount descending
    final sortedEntries = aggregated.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sortedEntries);
  }

  /// Calculate total from aggregated map
  static double calculateTotal(Map<String, double> aggregated) {
    return aggregated.values.fold(0.0, (sum, amount) => sum + amount);
  }

  /// Sort map by key in descending order (newest first)
  static Map<String, double> _sortMapByKeyDescending(Map<String, double> map) {
    final sortedEntries = map.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    return Map.fromEntries(sortedEntries);
  }
}

