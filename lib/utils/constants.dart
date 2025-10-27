import 'package:flutter/material.dart';

/// Predefined categories for transactions
class TransactionCategories {
  static const List<String> expenseCategories = [
    'Food',
    'Travel',
    'Bills',
    'Entertainment',
    'Shopping',
    'Healthcare',
    'Education',
    'Others',
  ];

  static const List<String> incomeCategories = [
    'Salary',
    'Business',
    'Investment',
    'Gift',
    'Others',
  ];

  /// Get icon for category
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'travel':
        return Icons.flight;
      case 'bills':
        return Icons.receipt_long;
      case 'entertainment':
        return Icons.movie;
      case 'shopping':
        return Icons.shopping_bag;
      case 'healthcare':
        return Icons.local_hospital;
      case 'education':
        return Icons.school;
      case 'salary':
        return Icons.work;
      case 'business':
        return Icons.business;
      case 'investment':
        return Icons.trending_up;
      case 'gift':
        return Icons.card_giftcard;
      default:
        return Icons.category;
    }
  }

  /// Get color for category
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'travel':
        return Colors.blue;
      case 'bills':
        return Colors.red;
      case 'entertainment':
        return Colors.purple;
      case 'shopping':
        return Colors.pink;
      case 'healthcare':
        return Colors.green;
      case 'education':
        return Colors.indigo;
      case 'salary':
        return Colors.teal;
      case 'business':
        return Colors.amber;
      case 'investment':
        return Colors.cyan;
      case 'gift':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }
}

/// Budget alert levels
enum BudgetAlertLevel {
  safe, // < 80%
  warning, // 80-100%
  exceeded, // > 100%
}

/// Get budget alert level based on spent vs budget amount
BudgetAlertLevel getBudgetAlertLevel(double spent, double budget) {
  if (budget == 0) return BudgetAlertLevel.safe;
  final percentage = (spent / budget) * 100;

  if (percentage > 100) return BudgetAlertLevel.exceeded;
  if (percentage >= 80) return BudgetAlertLevel.warning;
  return BudgetAlertLevel.safe;
}

/// Get color for budget alert level
Color getBudgetAlertColor(BudgetAlertLevel level) {
  switch (level) {
    case BudgetAlertLevel.safe:
      return Colors.green;
    case BudgetAlertLevel.warning:
      return Colors.orange;
    case BudgetAlertLevel.exceeded:
      return Colors.red;
  }
}
