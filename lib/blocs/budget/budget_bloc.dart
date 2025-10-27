import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../services/database_helper.dart';
import 'budget_event.dart';
import 'budget_state.dart';

/// BLoC for managing budget operations
class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final DatabaseHelper _databaseHelper;

  BudgetBloc({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance,
        super(const BudgetInitial()) {
    on<LoadBudgets>(_onLoadBudgets);
    on<LoadBudgetsByMonth>(_onLoadBudgetsByMonth);
    on<AddBudget>(_onAddBudget);
    on<UpdateBudget>(_onUpdateBudget);
    on<DeleteBudget>(_onDeleteBudget);
  }

  /// Load all budgets for current month
  Future<void> _onLoadBudgets(
    LoadBudgets event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      emit(const BudgetLoading());
      
      final currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
      final budgets = await _databaseHelper.readBudgetsByMonth(currentMonth);
      final expensesByCategory = await _databaseHelper.getExpensesByCategory(currentMonth);
      
      // Calculate budget statuses
      final Map<String, BudgetStatus> budgetStatuses = {};
      for (var budget in budgets) {
        final spent = expensesByCategory[budget.category] ?? 0.0;
        final remaining = budget.budgetAmount - spent;
        final percentage = budget.budgetAmount > 0 
            ? (spent / budget.budgetAmount) * 100 
            : 0.0;
        
        budgetStatuses[budget.category] = BudgetStatus(
          budget: budget,
          spent: spent,
          remaining: remaining,
          percentage: percentage,
        );
      }

      emit(BudgetLoaded(
        budgets: budgets,
        budgetStatuses: budgetStatuses,
      ));
    } catch (e) {
      emit(BudgetError('Failed to load budgets: ${e.toString()}'));
    }
  }

  /// Load budgets for a specific month
  Future<void> _onLoadBudgetsByMonth(
    LoadBudgetsByMonth event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      emit(const BudgetLoading());
      
      final budgets = await _databaseHelper.readBudgetsByMonth(event.month);
      final expensesByCategory = await _databaseHelper.getExpensesByCategory(event.month);
      
      // Calculate budget statuses
      final Map<String, BudgetStatus> budgetStatuses = {};
      for (var budget in budgets) {
        final spent = expensesByCategory[budget.category] ?? 0.0;
        final remaining = budget.budgetAmount - spent;
        final percentage = budget.budgetAmount > 0 
            ? (spent / budget.budgetAmount) * 100 
            : 0.0;
        
        budgetStatuses[budget.category] = BudgetStatus(
          budget: budget,
          spent: spent,
          remaining: remaining,
          percentage: percentage,
        );
      }

      emit(BudgetLoaded(
        budgets: budgets,
        budgetStatuses: budgetStatuses,
      ));
    } catch (e) {
      emit(BudgetError('Failed to load budgets: ${e.toString()}'));
    }
  }

  /// Add a new budget
  Future<void> _onAddBudget(
    AddBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      emit(const BudgetOperationInProgress());
      
      await _databaseHelper.createBudget(event.budget);
      
      // Reload budgets
      add(const LoadBudgets());
      
      emit(const BudgetOperationSuccess('Budget added successfully'));
    } catch (e) {
      emit(BudgetError('Failed to add budget: ${e.toString()}'));
    }
  }

  /// Update an existing budget
  Future<void> _onUpdateBudget(
    UpdateBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      emit(const BudgetOperationInProgress());
      
      await _databaseHelper.updateBudget(event.budget);
      
      // Reload budgets
      add(const LoadBudgets());
      
      emit(const BudgetOperationSuccess('Budget updated successfully'));
    } catch (e) {
      emit(BudgetError('Failed to update budget: ${e.toString()}'));
    }
  }

  /// Delete a budget
  Future<void> _onDeleteBudget(
    DeleteBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      await _databaseHelper.deleteBudget(event.id);
      
      // Reload budgets
      add(const LoadBudgets());
    } catch (e) {
      emit(BudgetError('Failed to delete budget: ${e.toString()}'));
    }
  }
}
