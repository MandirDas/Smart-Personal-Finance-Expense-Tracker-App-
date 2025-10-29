import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/transaction/transaction_bloc.dart';
import '../blocs/transaction/transaction_event.dart';
import '../blocs/transaction/transaction_state.dart';
import '../widgets/transaction_list_item.dart';
import '../services/export_service.dart';
import 'add_transaction_screen.dart';

/// Screen showing all transactions
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(const LoadTransactions());
  }

  void _refreshTransactions() {
    context.read<TransactionBloc>().add(const LoadTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        actions: [
          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoaded && state.transactions.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.file_download),
                  tooltip: 'Export to CSV',
                  onPressed: () async {
                    try {
                      await ExportService.exportTransactionsToCSV(
                        state.transactions,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Transactions exported successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Export failed: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionLoaded) {
            if (state.transactions.isEmpty) {
              return Center(
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).disabledColor,
                          ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.transactions.length,
              padding: const EdgeInsets.only(bottom: 80),
              itemBuilder: (context, index) {
                final transaction = state.transactions[index];
                return TransactionListItem(
                  transaction: transaction,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTransactionScreen(
                          transaction: transaction,
                        ),
                      ),
                    );
                    _refreshTransactions();
                  },
                  onDelete: () {
                    context.read<TransactionBloc>().add(
                          DeleteTransaction(transaction.id!),
                        );
                  },
                );
              },
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
          _refreshTransactions();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
