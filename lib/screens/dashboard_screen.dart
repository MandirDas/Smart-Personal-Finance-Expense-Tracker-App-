import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/transaction/transaction_bloc.dart';
import '../blocs/transaction/transaction_event.dart';
import '../blocs/transaction/transaction_state.dart';
import '../blocs/budget/budget_bloc.dart';
import '../blocs/budget/budget_event.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../blocs/theme/theme_state.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_list_item.dart';
import '../widgets/expense_chart.dart';
import '../services/database_helper.dart';
import '../utils/helpers.dart';
import 'transactions_screen.dart';
import 'budgets_screen.dart';

/// Dashboard screen showing overview of finances
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<TransactionBloc>().add(const LoadTransactions());
    context.read<BudgetBloc>().add(const LoadBudgets());
  }

  Future<void> _refreshData() async {
    context.read<TransactionBloc>().add(const LoadTransactions());
    context.read<BudgetBloc>().add(const LoadBudgets());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        actions: [
          // Theme Mode Selector
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return PopupMenuButton<ThemeMode>(
                icon: Icon(
                  themeState.themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : themeState.themeMode == ThemeMode.light
                          ? Icons.light_mode
                          : Icons.brightness_auto,
                ),
                tooltip: 'Theme',
                onSelected: (ThemeMode mode) {
                  context.read<ThemeBloc>().add(SetTheme(mode));
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<ThemeMode>(
                    value: ThemeMode.light,
                    child: Row(
                      children: [
                        Icon(
                          Icons.light_mode,
                          color: themeState.themeMode == ThemeMode.light
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Light',
                          style: TextStyle(
                            fontWeight: themeState.themeMode == ThemeMode.light
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<ThemeMode>(
                    value: ThemeMode.dark,
                    child: Row(
                      children: [
                        Icon(
                          Icons.dark_mode,
                          color: themeState.themeMode == ThemeMode.dark
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Dark',
                          style: TextStyle(
                            fontWeight: themeState.themeMode == ThemeMode.dark
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<ThemeMode>(
                    value: ThemeMode.system,
                    child: Row(
                      children: [
                        Icon(
                          Icons.brightness_auto,
                          color: themeState.themeMode == ThemeMode.system
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'System Default',
                          style: TextStyle(
                            fontWeight: themeState.themeMode == ThemeMode.system
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BudgetsScreen(),
                ),
              );
              _refreshData();
            },
            tooltip: 'Budgets',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TransactionError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is TransactionLoaded) {
              return _buildDashboard(context, state);
            }

            return const Center(child: Text('Something went wrong'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TransactionsScreen(),
            ),
          );
          _refreshData();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction'),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, TransactionLoaded state) {
    final currentMonth = getCurrentMonth();

    return FutureBuilder<Map<String, double>>(
      future: DatabaseHelper.instance.getExpensesByCategory(currentMonth),
      builder: (context, snapshot) {
        final expensesByCategory = snapshot.data ?? {};

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Balance Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: BalanceCard(
                      totalIncome: state.totalIncome,
                      totalExpenses: state.totalExpenses,
                      balance: state.balance,
                    ),
                  ),
                  // Expense Chart
                  ExpenseChart(expensesByCategory: expensesByCategory),
                  // Recent Transactions Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transactions',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TransactionsScreen(),
                              ),
                            );
                            _refreshData();
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Recent Transactions List
            state.transactions.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 64,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No transactions yet',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap + to add your first transaction',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // Show only last 10 transactions
                        if (index >= state.transactions.length || index >= 10) {
                          return null;
                        }
                        final transaction = state.transactions[index];
                        return TransactionListItem(
                          transaction: transaction,
                          onDelete: () {
                            context.read<TransactionBloc>().add(
                                  DeleteTransaction(transaction.id!),
                                );
                          },
                        );
                      },
                      childCount: state.transactions.length > 10
                          ? 10
                          : state.transactions.length,
                    ),
                  ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
          ],
        );
      },
    );
  }
}
