import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/budget/budget_bloc.dart';
import '../blocs/budget/budget_event.dart';
import '../models/budget_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

/// Screen for adding or editing a budget
class AddBudgetScreen extends StatefulWidget {
  final Budget? budget;

  const AddBudgetScreen({super.key, this.budget});

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  String? _selectedCategory;
  String _selectedMonth = getCurrentMonth();

  @override
  void initState() {
    super.initState();
    if (widget.budget != null) {
      _amountController.text = widget.budget!.budgetAmount.toString();
      _selectedCategory = widget.budget!.category;
      _selectedMonth = widget.budget!.month;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _saveBudget() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final budget = Budget(
        id: widget.budget?.id,
        category: _selectedCategory!,
        budgetAmount: amount,
        month: _selectedMonth,
      );

      if (widget.budget == null) {
        context.read<BudgetBloc>().add(AddBudget(budget));
      } else {
        context.read<BudgetBloc>().add(UpdateBudget(budget));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.budget != null;
    final categories = TransactionCategories.expenseCategories;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Budget' : 'Add Budget'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Delete Budget'),
                      content: const Text(
                          'Are you sure you want to delete this budget?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<BudgetBloc>().add(
                                  DeleteBudget(widget.budget!.id!),
                                );
                            Navigator.pop(dialogContext);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Set monthly budgets to track your spending and get alerts when you exceed limits.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Icon(
                          TransactionCategories.getCategoryIcon(category),
                          color:
                              TransactionCategories.getCategoryColor(category),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(category),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: validateCategory,
              ),
              const SizedBox(height: 16),
              // Budget Amount Field
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Budget Amount',
                  prefixText: '₹ ',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                  hintText: '0.00',
                  helperText:
                      'Maximum amount you want to spend in this category',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: validateAmount,
              ),
              const SizedBox(height: 16),
              // Month Selector
              DropdownButtonFormField<String>(
                value: _selectedMonth,
                decoration: const InputDecoration(
                  labelText: 'Month',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_month),
                ),
                items: _generateMonthOptions(),
                onChanged: (value) {
                  setState(() {
                    _selectedMonth = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              // Budget Guidelines
              _buildGuidelineCard(
                'Safe',
                'Spending below 80% of budget',
                Colors.green,
                Icons.check_circle,
              ),
              const SizedBox(height: 8),
              _buildGuidelineCard(
                'Warning',
                'Spending between 80-100% of budget',
                Colors.orange,
                Icons.warning,
              ),
              const SizedBox(height: 8),
              _buildGuidelineCard(
                'Exceeded',
                'Spending over 100% of budget',
                Colors.red,
                Icons.error,
              ),
              const SizedBox(height: 24),
              // Save Button
              ElevatedButton(
                onPressed: _saveBudget,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: Text(
                  isEditing ? 'Update Budget' : 'Create Budget',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuidelineCard(
      String title, String description, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _generateMonthOptions() {
    final List<DropdownMenuItem<String>> items = [];
    final now = DateTime.now();

    // Generate options for current month and next 11 months
    for (int i = 0; i < 12; i++) {
      final date = DateTime(now.year, now.month + i, 1);
      final monthKey = formatMonth(date);
      final monthDisplay = formatMonthDisplay(monthKey);

      items.add(
        DropdownMenuItem(
          value: monthKey,
          child: Text(monthDisplay),
        ),
      );
    }

    return items;
  }
}
