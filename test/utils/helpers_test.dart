import 'package:flutter_test/flutter_test.dart';
import 'package:finance_tracker_app/utils/helpers.dart';

void main() {
  group('Validation Helper Tests', () {
    group('validateAmount', () {
      test('should return error for null or empty value', () {
        expect(validateAmount(null), 'Please enter an amount');
        expect(validateAmount(''), 'Please enter an amount');
      });

      test('should return error for invalid number', () {
        expect(validateAmount('abc'), 'Please enter a valid number');
        expect(validateAmount('12.34.56'), 'Please enter a valid number');
      });

      test('should return error for zero or negative amount', () {
        expect(validateAmount('0'), 'Amount must be greater than 0');
        expect(validateAmount('-10'), 'Amount must be greater than 0');
      });

      test('should return null for valid amount', () {
        expect(validateAmount('100'), null);
        expect(validateAmount('12.50'), null);
        expect(validateAmount('0.01'), null);
      });
    });

    group('validateCategory', () {
      test('should return error for null or empty value', () {
        expect(validateCategory(null), 'Please select a category');
        expect(validateCategory(''), 'Please select a category');
      });

      test('should return null for valid category', () {
        expect(validateCategory('Food'), null);
        expect(validateCategory('Travel'), null);
      });
    });

    group('validateDescription', () {
      test('should always return null (description is optional)', () {
        expect(validateDescription(null), null);
        expect(validateDescription(''), null);
        expect(validateDescription('Some description'), null);
      });
    });
  });

  group('Currency Formatting Tests', () {
    test('formatCurrency should format correctly', () {
      expect(formatCurrency(100.0), '\$100.00');
      expect(formatCurrency(1234.56), '\$1,234.56');
      expect(formatCurrency(0.99), '\$0.99');
    });
  });

  group('Date Formatting Tests', () {
    test('formatDate should format correctly', () {
      final date = DateTime(2024, 10, 15);
      expect(formatDate(date), 'Oct 15, 2024');
    });

    test('formatMonth should format correctly', () {
      final date = DateTime(2024, 10, 15);
      expect(formatMonth(date), '2024-10');
    });

    test('getCurrentMonth should return current month in YYYY-MM format', () {
      final result = getCurrentMonth();
      expect(result.length, 7); // YYYY-MM
      expect(result[4], '-');
    });

    test('formatMonthDisplay should format correctly', () {
      expect(formatMonthDisplay('2024-10'), 'October 2024');
      expect(formatMonthDisplay('2024-01'), 'January 2024');
    });
  });

  group('Percentage Formatting Tests', () {
    test('formatPercentage should format correctly', () {
      expect(formatPercentage(50.0), '50.0%');
      expect(formatPercentage(75.5), '75.5%');
      expect(formatPercentage(100.0), '100.0%');
    });
  });
}
