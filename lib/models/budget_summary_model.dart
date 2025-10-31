class BudgetSummaryModel {
  final double totalMoney;
  final double totalFixedCosts;
  final double remainingBalance;
  final double dailyAllowance;
  final int remainingDays;
  final DateTime calculatedAt;

  BudgetSummaryModel({
    required this.totalMoney,
    required this.totalFixedCosts,
    required this.remainingBalance,
    required this.dailyAllowance,
    required this.remainingDays,
    required this.calculatedAt,
  });

  BudgetSummaryModel copyWith({
    double? totalMoney,
    double? totalFixedCosts,
    double? remainingBalance,
    double? dailyAllowance,
    int? remainingDays,
    DateTime? calculatedAt,
  }) {
    return BudgetSummaryModel(
      totalMoney: totalMoney ?? this.totalMoney,
      totalFixedCosts: totalFixedCosts ?? this.totalFixedCosts,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      dailyAllowance: dailyAllowance ?? this.dailyAllowance,
      remainingDays: remainingDays ?? this.remainingDays,
      calculatedAt: calculatedAt ?? this.calculatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalMoney': totalMoney,
      'totalFixedCosts': totalFixedCosts,
      'remainingBalance': remainingBalance,
      'dailyAllowance': dailyAllowance,
      'remainingDays': remainingDays,
      'calculatedAt': calculatedAt.toIso8601String(),
    };
  }

  factory BudgetSummaryModel.fromMap(Map<String, dynamic> map) {
    return BudgetSummaryModel(
      totalMoney: (map['totalMoney'] as num).toDouble(),
      totalFixedCosts: (map['totalFixedCosts'] as num).toDouble(),
      remainingBalance: (map['remainingBalance'] as num).toDouble(),
      dailyAllowance: (map['dailyAllowance'] as num).toDouble(),
      remainingDays: map['remainingDays'] as int,
      calculatedAt: DateTime.parse(map['calculatedAt'] as String),
    );
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }

  factory BudgetSummaryModel.fromFirestore(Map<String, dynamic> doc) {
    return BudgetSummaryModel.fromMap(doc);
  }
}

