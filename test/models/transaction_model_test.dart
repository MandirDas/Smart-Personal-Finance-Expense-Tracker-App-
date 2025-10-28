import 'package:flutter_test/flutter_test.dart';
import 'package:finance_tracker_app/models/transaction_model.dart';

void main() {
  group('Transaction Model Tests', () {
    test('Transaction should be created with all properties', () {
      final transaction = Transaction(
        id: 1,
        amount: 100.0,
        category: 'Food',
        date: DateTime(2024, 10, 1),
        description: 'Lunch',
        isIncome: false,
      );

      expect(transaction.id, 1);
      expect(transaction.amount, 100.0);
      expect(transaction.category, 'Food');
      expect(transaction.description, 'Lunch');
      expect(transaction.isIncome, false);
    });

    test('Transaction toMap should convert correctly', () {
      final transaction = Transaction(
        id: 1,
        amount: 100.0,
        category: 'Food',
        date: DateTime(2024, 10, 1),
        description: 'Lunch',
        isIncome: false,
      );

      final map = transaction.toMap();

      expect(map['id'], 1);
      expect(map['amount'], 100.0);
      expect(map['category'], 'Food');
      expect(map['description'], 'Lunch');
      expect(map['isIncome'], 0);
    });

    test('Transaction fromMap should create correctly', () {
      final map = {
        'id': 1,
        'amount': 100.0,
        'category': 'Food',
        'date': '2024-10-01T00:00:00.000',
        'description': 'Lunch',
        'isIncome': 0,
      };

      final transaction = Transaction.fromMap(map);

      expect(transaction.id, 1);
      expect(transaction.amount, 100.0);
      expect(transaction.category, 'Food');
      expect(transaction.description, 'Lunch');
      expect(transaction.isIncome, false);
    });

    test('Transaction copyWith should update properties', () {
      final transaction = Transaction(
        id: 1,
        amount: 100.0,
        category: 'Food',
        date: DateTime(2024, 10, 1),
        description: 'Lunch',
        isIncome: false,
      );

      final updated =
          transaction.copyWith(amount: 150.0, description: 'Dinner');

      expect(updated.amount, 150.0);
      expect(updated.description, 'Dinner');
      expect(updated.category, 'Food'); // Unchanged
      expect(updated.isIncome, false); // Unchanged
    });

    test('Two transactions with same properties should be equal', () {
      final transaction1 = Transaction(
        id: 1,
        amount: 100.0,
        category: 'Food',
        date: DateTime(2024, 10, 1),
        description: 'Lunch',
        isIncome: false,
      );

      final transaction2 = Transaction(
        id: 1,
        amount: 100.0,
        category: 'Food',
        date: DateTime(2024, 10, 1),
        description: 'Lunch',
        isIncome: false,
      );

      expect(transaction1, transaction2);
    });
  });
}
