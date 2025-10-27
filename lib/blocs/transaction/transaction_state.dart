import 'package:equatable/equatable.dart';
import '../../models/transaction_model.dart';

/// Base class for all Transaction states
abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any transactions are loaded
class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

/// State when transactions are being loaded
class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

/// State when transactions are successfully loaded
class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  final double totalIncome;
  final double totalExpenses;
  final double balance;

  const TransactionLoaded({
    required this.transactions,
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
  });

  @override
  List<Object?> get props =>
      [transactions, totalIncome, totalExpenses, balance];

  /// Create a copy with updated values
  TransactionLoaded copyWith({
    List<Transaction>? transactions,
    double? totalIncome,
    double? totalExpenses,
    double? balance,
  }) {
    return TransactionLoaded(
      transactions: transactions ?? this.transactions,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      balance: balance ?? this.balance,
    );
  }
}

/// State when a transaction operation is in progress
class TransactionOperationInProgress extends TransactionState {
  const TransactionOperationInProgress();
}

/// State when a transaction operation succeeds
class TransactionOperationSuccess extends TransactionState {
  final String message;

  const TransactionOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when a transaction operation fails
class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}
