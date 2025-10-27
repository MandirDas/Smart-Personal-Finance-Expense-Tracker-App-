import 'package:equatable/equatable.dart';
import '../../models/budget_model.dart';

/// Base class for all Budget events
abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all budgets
class LoadBudgets extends BudgetEvent {
  const LoadBudgets();
}

/// Event to load budgets for a specific month
class LoadBudgetsByMonth extends BudgetEvent {
  final String month; // Format: YYYY-MM

  const LoadBudgetsByMonth(this.month);

  @override
  List<Object?> get props => [month];
}

/// Event to add a new budget
class AddBudget extends BudgetEvent {
  final Budget budget;

  const AddBudget(this.budget);

  @override
  List<Object?> get props => [budget];
}

/// Event to update an existing budget
class UpdateBudget extends BudgetEvent {
  final Budget budget;

  const UpdateBudget(this.budget);

  @override
  List<Object?> get props => [budget];
}

/// Event to delete a budget
class DeleteBudget extends BudgetEvent {
  final int id;

  const DeleteBudget(this.id);

  @override
  List<Object?> get props => [id];
}
