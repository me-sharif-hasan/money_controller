class VaultModel {
  final double balance;
  final List<VaultTransaction> transactions;

  VaultModel({
    required this.balance,
    required this.transactions,
  });

  VaultModel copyWith({
    double? balance,
    List<VaultTransaction>? transactions,
  }) {
    return VaultModel(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
      'transactions': transactions.map((t) => t.toMap()).toList(),
    };
  }

  factory VaultModel.fromMap(Map<String, dynamic> map) {
    return VaultModel(
      balance: (map['balance'] as num).toDouble(),
      transactions: (map['transactions'] as List<dynamic>)
          .map((t) => VaultTransaction.fromMap(t as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }

  factory VaultModel.fromFirestore(Map<String, dynamic> doc) {
    return VaultModel.fromMap(doc);
  }
}

class VaultTransaction {
  final String id;
  final double amount;
  final DateTime date;
  final String type;
  final DateTime createdAt;

  VaultTransaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.type,
    required this.createdAt,
  });

  VaultTransaction copyWith({
    String? id,
    double? amount,
    DateTime? date,
    String? type,
    DateTime? createdAt,
  }) {
    return VaultTransaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory VaultTransaction.fromMap(Map<String, dynamic> map) {
    return VaultTransaction(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      type: map['type'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}

