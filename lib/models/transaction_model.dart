import 'package:equatable/equatable.dart';

/// Transaction model representing a financial transaction (income or expense)
class Transaction extends Equatable {
  final int? id;
  final double amount;
  final String category;
  final DateTime date;
  final String description;
  final bool isIncome;

  const Transaction({
    this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
    this.isIncome = false,
  });

  /// Create Transaction from database map
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int?,
      amount: map['amount'] as double,
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String,
      isIncome: map['isIncome'] == 1,
    );
  }

  /// Convert Transaction to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'description': description,
      'isIncome': isIncome ? 1 : 0,
    };
  }

  /// Create copy of Transaction with updated fields
  Transaction copyWith({
    int? id,
    double? amount,
    String? category,
    DateTime? date,
    String? description,
    bool? isIncome,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  @override
  List<Object?> get props => [id, amount, category, date, description, isIncome];

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, category: $category, date: $date, description: $description, isIncome: $isIncome)';
  }
}
