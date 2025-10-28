import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finance_tracker_app/widgets/balance_card.dart';

void main() {
  group('BalanceCard Widget Tests', () {
    testWidgets('should display total balance correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(
              totalIncome: 1000.0,
              totalExpenses: 600.0,
              balance: 400.0,
            ),
          ),
        ),
      );

      expect(find.text('Total Balance'), findsOneWidget);
      expect(find.text('\$400.00'), findsOneWidget);
    });

    testWidgets('should display income and expenses',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(
              totalIncome: 1000.0,
              totalExpenses: 600.0,
              balance: 400.0,
            ),
          ),
        ),
      );

      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);
      expect(find.text('\$1,000.00'), findsOneWidget);
      expect(find.text('\$600.00'), findsOneWidget);
    });

    testWidgets('should display negative balance correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(
              totalIncome: 500.0,
              totalExpenses: 800.0,
              balance: -300.0,
            ),
          ),
        ),
      );

      expect(find.text('-\$300.00'), findsOneWidget);
    });

    testWidgets('should use gradient background', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(
              totalIncome: 1000.0,
              totalExpenses: 600.0,
              balance: 400.0,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(Card),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
    });
  });
}
