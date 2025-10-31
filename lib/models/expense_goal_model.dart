class ExpenseGoalModel {
  final String id;
  final String title;
  final double amount;
  final DateTime targetDate;
  final DateTime createdAt;
  final bool isCompleted;
  final double savedAmount;

  ExpenseGoalModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.targetDate,
    required this.createdAt,
    this.isCompleted = false,
    this.savedAmount = 0.0,
  });

  int get daysUntilTarget {
    final now = DateTime.now();
    final difference = targetDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }

  double get dailyRequirement {
    final days = daysUntilTarget;
    if (days <= 0) return 0.0;
    final remaining = amount - savedAmount;
    return remaining > 0 ? remaining / days : 0.0;
  }

  bool get isOverdue {
    return DateTime.now().isAfter(targetDate) && !isCompleted;
  }

  double get progressPercentage {
    if (amount <= 0) return 0.0;
    return (savedAmount / amount) * 100;
  }

  ExpenseGoalModel copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? targetDate,
    DateTime? createdAt,
    bool? isCompleted,
    double? savedAmount,
  }) {
    return ExpenseGoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      savedAmount: savedAmount ?? this.savedAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'targetDate': targetDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted,
      'savedAmount': savedAmount,
    };
  }

  factory ExpenseGoalModel.fromMap(Map<String, dynamic> map) {
    return ExpenseGoalModel(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      targetDate: DateTime.parse(map['targetDate'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      isCompleted: map['isCompleted'] as bool? ?? false,
      savedAmount: (map['savedAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }

  factory ExpenseGoalModel.fromFirestore(Map<String, dynamic> doc) {
    return ExpenseGoalModel.fromMap(doc);
  }
}

