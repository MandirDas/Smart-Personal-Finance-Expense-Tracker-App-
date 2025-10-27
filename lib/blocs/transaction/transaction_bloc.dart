import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/database_helper.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

/// BLoC for managing transaction operations
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final DatabaseHelper _databaseHelper;

  TransactionBloc({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance,
        super(const TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<LoadTransactionsByMonth>(_onLoadTransactionsByMonth);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<UndoDeleteTransaction>(_onUndoDeleteTransaction);
  }

  /// Load all transactions
  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      emit(const TransactionLoading());
      
      final transactions = await _databaseHelper.readAllTransactions();
      final totalIncome = await _databaseHelper.getTotalIncome();
      final totalExpenses = await _databaseHelper.getTotalExpenses();
      final balance = totalIncome - totalExpenses;

      emit(TransactionLoaded(
        transactions: transactions,
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        balance: balance,
      ));
    } catch (e) {
      emit(TransactionError('Failed to load transactions: ${e.toString()}'));
    }
  }

  /// Load transactions for a specific month
  Future<void> _onLoadTransactionsByMonth(
    LoadTransactionsByMonth event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      emit(const TransactionLoading());
      
      final transactions = await _databaseHelper.readTransactionsByMonth(event.month);
      
      // Calculate totals for the month
      double totalIncome = 0;
      double totalExpenses = 0;
      
      for (var transaction in transactions) {
        if (transaction.isIncome) {
          totalIncome += transaction.amount;
        } else {
          totalExpenses += transaction.amount;
        }
      }
      
      final balance = totalIncome - totalExpenses;

      emit(TransactionLoaded(
        transactions: transactions,
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        balance: balance,
      ));
    } catch (e) {
      emit(TransactionError('Failed to load transactions: ${e.toString()}'));
    }
  }

  /// Add a new transaction
  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      emit(const TransactionOperationInProgress());
      
      await _databaseHelper.createTransaction(event.transaction);
      
      // Reload all transactions
      add(const LoadTransactions());
      
      emit(const TransactionOperationSuccess('Transaction added successfully'));
    } catch (e) {
      emit(TransactionError('Failed to add transaction: ${e.toString()}'));
    }
  }

  /// Update an existing transaction
  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      emit(const TransactionOperationInProgress());
      
      await _databaseHelper.updateTransaction(event.transaction);
      
      // Reload all transactions
      add(const LoadTransactions());
      
      emit(const TransactionOperationSuccess('Transaction updated successfully'));
    } catch (e) {
      emit(TransactionError('Failed to update transaction: ${e.toString()}'));
    }
  }

  /// Delete a transaction
  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await _databaseHelper.deleteTransaction(event.id);
      
      // Reload all transactions
      add(const LoadTransactions());
    } catch (e) {
      emit(TransactionError('Failed to delete transaction: ${e.toString()}'));
    }
  }

  /// Undo transaction deletion
  Future<void> _onUndoDeleteTransaction(
    UndoDeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await _databaseHelper.createTransaction(event.transaction);
      
      // Reload all transactions
      add(const LoadTransactions());
    } catch (e) {
      emit(TransactionError('Failed to undo deletion: ${e.toString()}'));
    }
  }
}
