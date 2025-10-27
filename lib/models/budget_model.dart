import 'package:equatable/equatable.dart';

/// Budget model representing monthly budget per category
class Budget extends Equatable {
  final int? id;
  final String category;
  final double budgetAmount;
  final String month; // Format: YYYY-MM

  const Budget({
    this.id,
    required this.category,
    required this.budgetAmount,
    required this.month,
  });

  /// Create Budget from database map
  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'] as int?,
      category: map['category'] as String,
      budgetAmount: map['budgetAmount'] as double,
      month: map['month'] as String,
    );
  }

  /// Convert Budget to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'budgetAmount': budgetAmount,
      'month': month,
    };
  }

  /// Create copy of Budget with updated fields
  Budget copyWith({
    int? id,
    String? category,
    double? budgetAmount,
    String? month,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      month: month ?? this.month,
    );
  }

  @override
  List<Object?> get props => [id, category, budgetAmount, month];

  @override
  String toString() {
    return 'Budget(id: $id, category: $category, budgetAmount: $budgetAmount, month: $month)';
  }
}
