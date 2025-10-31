double calculateDailyAllowance(double total, double fixed, int remainingDays) {
  if (remainingDays <= 0) return 0;
  final remaining = total - fixed;
  return remaining / remainingDays;
}

double calculateDailyAllowanceWithGoals(double total, double fixed, int remainingDays, double goalRequirement) {
  if (remainingDays <= 0) return 0;
  final remaining = total - fixed;
  final baseAllowance = remaining / remainingDays;
  return baseAllowance - goalRequirement;
}

double calculateSavingNeed(double goal, int remainingDays) {
  if (remainingDays <= 0) return goal;
  return goal / remainingDays;
}

double adjustAllowance(double spent, double allowance, bool flexible) {
  if (flexible) {
    return allowance - spent;
  }
  return 0;
}

double recalculateAfterAddition(double currentBalance, double added, int remainingDays) {
  if (remainingDays <= 0) return currentBalance + added;
  return (currentBalance + added) / remainingDays;
}

double vaultTransferImpact(double currentAllowance, double transfer, bool flexibleMode) {
  if (flexibleMode) {
    return currentAllowance - transfer;
  }
  return currentAllowance - transfer;
}

double calculateTotalFixedCosts(List<Map<String, dynamic>> fixedCosts) {
  return fixedCosts.fold(0.0, (sum, cost) => sum + (cost['amount'] as num).toDouble());
}

double calculateTotalExpenses(List<Map<String, dynamic>> expenses) {
  return expenses.fold(0.0, (sum, expense) => sum + (expense['amount'] as num).toDouble());
}

double calculateProgress(double current, double goal) {
  if (goal <= 0) return 0;
  return (current / goal) * 100;
}

