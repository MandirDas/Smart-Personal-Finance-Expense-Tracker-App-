import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart' as model;
import '../models/budget_model.dart';

/// Database helper for managing SQLite database operations
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('finance_tracker.db');
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Create database tables
  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';
    const intType = 'INTEGER NOT NULL';

    // Create transactions table
    await db.execute('''
      CREATE TABLE transactions (
        id $idType,
        amount $realType,
        category $textType,
        date $textType,
        description $textType,
        isIncome $intType
      )
    ''');

    // Create budgets table
    await db.execute('''
      CREATE TABLE budgets (
        id $idType,
        category $textType,
        budgetAmount $realType,
        month $textType,
        UNIQUE(category, month)
      )
    ''');
  }

  // ==================== TRANSACTION CRUD ====================

  /// Create a new transaction
  Future<model.Transaction> createTransaction(
      model.Transaction transaction) async {
    final db = await instance.database;
    final id = await db.insert('transactions', transaction.toMap());
    return transaction.copyWith(id: id);
  }

  /// Read a single transaction by id
  Future<model.Transaction?> readTransaction(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'transactions',
      columns: ['id', 'amount', 'category', 'date', 'description', 'isIncome'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return model.Transaction.fromMap(maps.first);
    } else {
      return null;
    }
  }

  /// Read all transactions
  Future<List<model.Transaction>> readAllTransactions() async {
    final db = await instance.database;
    const orderBy = 'date DESC';
    final result = await db.query('transactions', orderBy: orderBy);
    return result.map((map) => model.Transaction.fromMap(map)).toList();
  }

  /// Read transactions for a specific month
  Future<List<model.Transaction>> readTransactionsByMonth(String month) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'date LIKE ?',
      whereArgs: ['$month%'],
      orderBy: 'date DESC',
    );
    return result.map((map) => model.Transaction.fromMap(map)).toList();
  }

  /// Read transactions by category
  Future<List<model.Transaction>> readTransactionsByCategory(
      String category) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'date DESC',
    );
    return result.map((map) => model.Transaction.fromMap(map)).toList();
  }

  /// Update a transaction
  Future<int> updateTransaction(model.Transaction transaction) async {
    final db = await instance.database;
    return db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  /// Delete a transaction
  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== BUDGET CRUD ====================

  /// Create a new budget
  Future<Budget> createBudget(Budget budget) async {
    final db = await instance.database;
    final id = await db.insert(
      'budgets',
      budget.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return budget.copyWith(id: id);
  }

  /// Read a single budget by id
  Future<Budget?> readBudget(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'budgets',
      columns: ['id', 'category', 'budgetAmount', 'month'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Budget.fromMap(maps.first);
    } else {
      return null;
    }
  }

  /// Read all budgets
  Future<List<Budget>> readAllBudgets() async {
    final db = await instance.database;
    final result =
        await db.query('budgets', orderBy: 'month DESC, category ASC');
    return result.map((map) => Budget.fromMap(map)).toList();
  }

  /// Read budgets for a specific month
  Future<List<Budget>> readBudgetsByMonth(String month) async {
    final db = await instance.database;
    final result = await db.query(
      'budgets',
      where: 'month = ?',
      whereArgs: [month],
      orderBy: 'category ASC',
    );
    return result.map((map) => Budget.fromMap(map)).toList();
  }

  /// Update a budget
  Future<int> updateBudget(Budget budget) async {
    final db = await instance.database;
    return db.update(
      'budgets',
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  /// Delete a budget
  Future<int> deleteBudget(int id) async {
    final db = await instance.database;
    return await db.delete(
      'budgets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== UTILITY METHODS ====================

  /// Get total income
  Future<double> getTotalIncome() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE isIncome = 1',
    );
    return (result.first['total'] as double?) ?? 0.0;
  }

  /// Get total expenses
  Future<double> getTotalExpenses() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE isIncome = 0',
    );
    return (result.first['total'] as double?) ?? 0.0;
  }

  /// Get expenses by category for a specific month
  Future<Map<String, double>> getExpensesByCategory(String month) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT category, SUM(amount) as total FROM transactions WHERE date LIKE ? AND isIncome = 0 GROUP BY category',
      ['$month%'],
    );

    final Map<String, double> expenses = {};
    for (var row in result) {
      expenses[row['category'] as String] = row['total'] as double;
    }
    return expenses;
  }

  /// Close database
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
