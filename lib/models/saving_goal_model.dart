class SavingGoalModel {
  final double monthlyGoal;
  final DateTime createdAt;
  final DateTime updatedAt;

  SavingGoalModel({
    required this.monthlyGoal,
    required this.createdAt,
    required this.updatedAt,
  });

  SavingGoalModel copyWith({
    double? monthlyGoal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SavingGoalModel(
      monthlyGoal: monthlyGoal ?? this.monthlyGoal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'monthlyGoal': monthlyGoal,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SavingGoalModel.fromMap(Map<String, dynamic> map) {
    return SavingGoalModel(
      monthlyGoal: (map['monthlyGoal'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }

  factory SavingGoalModel.fromFirestore(Map<String, dynamic> doc) {
    return SavingGoalModel.fromMap(doc);
  }
}

