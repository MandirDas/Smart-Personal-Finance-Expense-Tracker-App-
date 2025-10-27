import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

/// Service for exporting transactions to CSV
class ExportService {
  /// Export transactions to CSV and share
  static Future<void> exportTransactionsToCSV(
    List<Transaction> transactions,
  ) async {
    try {
      // Create CSV data
      final List<List<dynamic>> csvData = [
        ['Date', 'Amount', 'Category', 'Description', 'Type'],
        ...transactions.map((transaction) => [
              DateFormat('yyyy-MM-dd').format(transaction.date),
              transaction.amount.toStringAsFixed(2),
              transaction.category,
              transaction.description,
              transaction.isIncome ? 'Income' : 'Expense',
            ]),
      ];

      // Convert to CSV string
      final String csv = const ListToCsvConverter().convert(csvData);

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final path =
          '${directory.path}/transactions_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';

      // Write to file
      final file = File(path);
      await file.writeAsString(csv);

      // Share the file
      await Share.shareXFiles(
        [XFile(path)],
        subject: 'Transaction Export',
        text: 'Exported ${transactions.length} transactions',
      );
    } catch (e) {
      throw Exception('Failed to export transactions: ${e.toString()}');
    }
  }

  /// Get summary statistics for transactions
  static Map<String, dynamic> getTransactionSummary(
    List<Transaction> transactions,
  ) {
    double totalIncome = 0;
    double totalExpenses = 0;
    final Map<String, double> categoryTotals = {};

    for (var transaction in transactions) {
      if (transaction.isIncome) {
        totalIncome += transaction.amount;
      } else {
        totalExpenses += transaction.amount;
        categoryTotals[transaction.category] =
            (categoryTotals[transaction.category] ?? 0) + transaction.amount;
      }
    }

    return {
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'balance': totalIncome - totalExpenses,
      'transactionCount': transactions.length,
      'categoryTotals': categoryTotals,
    };
  }
}
