import 'package:equatable/equatable.dart';
import '../../models/budget_model.dart';

/// Budget status for a category
class BudgetStatus {
  final Budget budget;
  final double spent;
  final double remaining;
  final double percentage;

  const BudgetStatus({
    required this.budget,
    required this.spent,
    required this.remaining,
    required this.percentage,
  });

  bool get isOverBudget => percentage > 100;
  bool get isWarning => percentage >= 80 && percentage <= 100;
  bool get isSafe => percentage < 80;
}

/// Base class for all Budget states
abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any budgets are loaded
class BudgetInitial extends BudgetState {
  const BudgetInitial();
}

/// State when budgets are being loaded
class BudgetLoading extends BudgetState {
  const BudgetLoading();
}

/// State when budgets are successfully loaded
class BudgetLoaded extends BudgetState {
  final List<Budget> budgets;
  final Map<String, BudgetStatus> budgetStatuses;

  const BudgetLoaded({
    required this.budgets,
    required this.budgetStatuses,
  });

  @override
  List<Object?> get props => [budgets, budgetStatuses];
}

/// State when a budget operation is in progress
class BudgetOperationInProgress extends BudgetState {
  const BudgetOperationInProgress();
}

/// State when a budget operation succeeds
class BudgetOperationSuccess extends BudgetState {
  final String message;

  const BudgetOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when a budget operation fails
class BudgetError extends BudgetState {
  final String message;

  const BudgetError(this.message);

  @override
  List<Object?> get props => [message];
}
