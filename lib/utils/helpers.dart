import 'package:intl/intl.dart';

/// Format currency amount
String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
  return formatter.format(amount);
}

/// Format date
String formatDate(DateTime date) {
  return DateFormat('MMM dd, yyyy').format(date);
}

/// Format date with time
String formatDateTime(DateTime date) {
  return DateFormat('MMM dd, yyyy HH:mm').format(date);
}

/// Format month (YYYY-MM)
String formatMonth(DateTime date) {
  return DateFormat('yyyy-MM').format(date);
}

/// Format month for display (e.g., "January 2024")
String formatMonthDisplay(String month) {
  try {
    final date = DateTime.parse('$month-01');
    return DateFormat('MMMM yyyy').format(date);
  } catch (e) {
    return month;
  }
}

/// Get current month in YYYY-MM format
String getCurrentMonth() {
  return DateFormat('yyyy-MM').format(DateTime.now());
}

/// Parse month from display format
DateTime parseMonth(String monthDisplay) {
  return DateFormat('MMMM yyyy').parse(monthDisplay);
}

/// Get month name
String getMonthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return months[month - 1];
}

/// Format percentage
String formatPercentage(double percentage) {
  return '${percentage.toStringAsFixed(1)}%';
}

/// Validate amount input
String? validateAmount(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an amount';
  }

  final amount = double.tryParse(value);
  if (amount == null) {
    return 'Please enter a valid number';
  }

  if (amount <= 0) {
    return 'Amount must be greater than 0';
  }

  return null;
}

/// Validate category selection
String? validateCategory(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select a category';
  }
  return null;
}

/// Validate description
String? validateDescription(String? value) {
  // Description is optional, so always return null
  return null;
}
