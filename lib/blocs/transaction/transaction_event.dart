import 'package:equatable/equatable.dart';
import '../../models/transaction_model.dart';

/// Base class for all Transaction events
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all transactions
class LoadTransactions extends TransactionEvent {
  const LoadTransactions();
}

/// Event to load transactions for a specific month
class LoadTransactionsByMonth extends TransactionEvent {
  final String month; // Format: YYYY-MM

  const LoadTransactionsByMonth(this.month);

  @override
  List<Object?> get props => [month];
}

/// Event to add a new transaction
class AddTransaction extends TransactionEvent {
  final Transaction transaction;

  const AddTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

/// Event to update an existing transaction
class UpdateTransaction extends TransactionEvent {
  final Transaction transaction;

  const UpdateTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

/// Event to delete a transaction
class DeleteTransaction extends TransactionEvent {
  final int id;

  const DeleteTransaction(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to undo transaction deletion
class UndoDeleteTransaction extends TransactionEvent {
  final Transaction transaction;

  const UndoDeleteTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}
