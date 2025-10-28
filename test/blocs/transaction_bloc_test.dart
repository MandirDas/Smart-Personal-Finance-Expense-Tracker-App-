import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finance_tracker_app/blocs/transaction/transaction_bloc.dart';
import 'package:finance_tracker_app/blocs/transaction/transaction_event.dart';
import 'package:finance_tracker_app/blocs/transaction/transaction_state.dart';
import 'package:finance_tracker_app/models/transaction_model.dart';
import 'package:finance_tracker_app/services/database_helper.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late MockDatabaseHelper mockDatabaseHelper;
  late TransactionBloc transactionBloc;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    transactionBloc = TransactionBloc(databaseHelper: mockDatabaseHelper);
  });

  tearDown(() {
    transactionBloc.close();
  });

  group('TransactionBloc Tests', () {
    final testTransactions = [
      Transaction(
        id: 1,
        amount: 100.0,
        category: 'Food',
        date: DateTime(2024, 10, 1),
        description: 'Lunch',
        isIncome: false,
      ),
      Transaction(
        id: 2,
        amount: 50.0,
        category: 'Travel',
        date: DateTime(2024, 10, 2),
        description: 'Bus fare',
        isIncome: false,
      ),
    ];

    test('initial state should be TransactionInitial', () {
      expect(transactionBloc.state, const TransactionInitial());
    });

    blocTest<TransactionBloc, TransactionState>(
      'emits [TransactionLoading, TransactionLoaded] when LoadTransactions is added',
      build: () {
        when(() => mockDatabaseHelper.readAllTransactions())
            .thenAnswer((_) async => testTransactions);
        when(() => mockDatabaseHelper.getTotalIncome())
            .thenAnswer((_) async => 0.0);
        when(() => mockDatabaseHelper.getTotalExpenses())
            .thenAnswer((_) async => 150.0);
        return transactionBloc;
      },
      act: (bloc) => bloc.add(const LoadTransactions()),
      expect: () => [
        const TransactionLoading(),
        TransactionLoaded(
          transactions: testTransactions,
          totalIncome: 0.0,
          totalExpenses: 150.0,
          balance: -150.0,
        ),
      ],
      verify: (_) {
        verify(() => mockDatabaseHelper.readAllTransactions()).called(1);
        verify(() => mockDatabaseHelper.getTotalIncome()).called(1);
        verify(() => mockDatabaseHelper.getTotalExpenses()).called(1);
      },
    );

    blocTest<TransactionBloc, TransactionState>(
      'emits [TransactionOperationInProgress, TransactionOperationSuccess] when AddTransaction is added',
      build: () {
        when(() => mockDatabaseHelper.createTransaction(any()))
            .thenAnswer((_) async => testTransactions[0]);
        when(() => mockDatabaseHelper.readAllTransactions())
            .thenAnswer((_) async => testTransactions);
        when(() => mockDatabaseHelper.getTotalIncome())
            .thenAnswer((_) async => 0.0);
        when(() => mockDatabaseHelper.getTotalExpenses())
            .thenAnswer((_) async => 150.0);
        return transactionBloc;
      },
      act: (bloc) => bloc.add(AddTransaction(testTransactions[0])),
      expect: () => [
        const TransactionOperationInProgress(),
        const TransactionOperationSuccess('Transaction added successfully'),
        const TransactionLoading(),
        TransactionLoaded(
          transactions: testTransactions,
          totalIncome: 0.0,
          totalExpenses: 150.0,
          balance: -150.0,
        ),
      ],
      verify: (_) {
        verify(() => mockDatabaseHelper.createTransaction(any())).called(1);
      },
    );

    blocTest<TransactionBloc, TransactionState>(
      'emits TransactionError when loading fails',
      build: () {
        when(() => mockDatabaseHelper.readAllTransactions())
            .thenThrow(Exception('Database error'));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(const LoadTransactions()),
      expect: () => [
        const TransactionLoading(),
        const TransactionError(
            'Failed to load transactions: Exception: Database error'),
      ],
    );
  });
}
