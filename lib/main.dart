import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/transaction/transaction_bloc.dart';
import 'blocs/budget/budget_bloc.dart';
import 'blocs/theme/theme_bloc.dart';
import 'blocs/theme/theme_event.dart';
import 'blocs/theme/theme_state.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TransactionBloc()),
        BlocProvider(create: (context) => BudgetBloc()),
        BlocProvider(
          create: (context) => ThemeBloc()..add(const LoadTheme()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Finance Tracker',
            debugShowCheckedModeBanner: false,
            themeMode: state.themeMode,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              cardTheme: CardTheme(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              cardTheme: CardTheme(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
            ),
            home: const DashboardWrapper(),
          );
        },
      ),
    );
  }
}

class DashboardWrapper extends StatelessWidget {
  const DashboardWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const DashboardScreen(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: 48,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Finance Tracker',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Manage your money wisely',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                String themeText = 'Light';
                IconData themeIcon = Icons.light_mode;
                
                if (state.themeMode == ThemeMode.dark) {
                  themeText = 'Dark';
                  themeIcon = Icons.dark_mode;
                } else if (state.themeMode == ThemeMode.system) {
                  themeText = 'System Default';
                  themeIcon = Icons.brightness_auto;
                }
                
                return ListTile(
                  leading: Icon(themeIcon),
                  title: const Text('Theme'),
                  subtitle: Text(themeText),
                  onTap: () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'Finance Tracker',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(
                    Icons.account_balance_wallet,
                    size: 48,
                    color: Colors.blue,
                  ),
                  children: [
                    const Text(
                      'A smart personal finance and expense tracker app built with Flutter.',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
