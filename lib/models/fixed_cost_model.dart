class FixedCostModel {
  final String id;
  final String name;
  final double amount;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  FixedCostModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  FixedCostModel copyWith({
    String? id,
    String? name,
    double? amount,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FixedCostModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory FixedCostModel.fromMap(Map<String, dynamic> map) {
    return FixedCostModel(
      id: map['id'] as String,
      name: map['name'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }

  factory FixedCostModel.fromFirestore(Map<String, dynamic> doc) {
    return FixedCostModel.fromMap(doc);
  }
}

