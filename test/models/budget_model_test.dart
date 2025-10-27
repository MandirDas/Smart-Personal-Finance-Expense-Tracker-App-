import 'package:flutter_test/flutter_test.dart';
import 'package:finance_tracker_app/models/budget_model.dart';

void main() {
  group('Budget Model Tests', () {
    test('Budget should be created with all properties', () {
      final budget = Budget(
        id: 1,
        category: 'Food',
        budgetAmount: 500.0,
        month: '2024-10',
      );

      expect(budget.id, 1);
      expect(budget.category, 'Food');
      expect(budget.budgetAmount, 500.0);
      expect(budget.month, '2024-10');
    });

    test('Budget toMap should convert correctly', () {
      final budget = Budget(
        id: 1,
        category: 'Food',
        budgetAmount: 500.0,
        month: '2024-10',
      );

      final map = budget.toMap();

      expect(map['id'], 1);
      expect(map['category'], 'Food');
      expect(map['budgetAmount'], 500.0);
      expect(map['month'], '2024-10');
    });

    test('Budget fromMap should create correctly', () {
      final map = {
        'id': 1,
        'category': 'Food',
        'budgetAmount': 500.0,
        'month': '2024-10',
      };

      final budget = Budget.fromMap(map);

      expect(budget.id, 1);
      expect(budget.category, 'Food');
      expect(budget.budgetAmount, 500.0);
      expect(budget.month, '2024-10');
    });

    test('Budget copyWith should update properties', () {
      final budget = Budget(
        id: 1,
        category: 'Food',
        budgetAmount: 500.0,
        month: '2024-10',
      );

      final updated = budget.copyWith(budgetAmount: 600.0);

      expect(updated.budgetAmount, 600.0);
      expect(updated.category, 'Food'); // Unchanged
      expect(updated.month, '2024-10'); // Unchanged
    });

    test('Two budgets with same properties should be equal', () {
      final budget1 = Budget(
        id: 1,
        category: 'Food',
        budgetAmount: 500.0,
        month: '2024-10',
      );

      final budget2 = Budget(
        id: 1,
        category: 'Food',
        budgetAmount: 500.0,
        month: '2024-10',
      );

      expect(budget1, budget2);
    });
  });
}
