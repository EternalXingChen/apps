import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';
import '../models/journal_model.dart';
import '../models/task_model.dart';
import '../models/category_model.dart';
import '../utils/security_utils.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;
  final _securityUtils = SecurityUtils();

  Future Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'lifeflow.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Categories table
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        icon TEXT,
        color TEXT,
        isDefault INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');

    // Transactions table
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        amount REAL NOT NULL,
        categoryId TEXT NOT NULL,
        accountType TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        note TEXT,
        tags TEXT,
        isEncrypted INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories(id)
      )
    ''');

    // Journals table
    await db.execute('''
      CREATE TABLE journals (
        id TEXT PRIMARY KEY,
        content TEXT NOT NULL,
        moodId INTEGER,
        mediaUrls TEXT,
        location TEXT,
        weather TEXT,
        isEncrypted INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Tasks table
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        dueTime TEXT,
        priority INTEGER DEFAULT 0,
        repeatRule TEXT,
        categoryId TEXT,
        isCompleted INTEGER DEFAULT 0,
        reminderMinutes INTEGER,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories(id)
      )
    ''');

    // Settings table
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    // Insert default categories
    await _insertDefaultCategories(db);
  }

  Future<void> _insertDefaultCategories(Database db) async {
    final defaultCategories = [
      // Expense categories
      {'id': 'exp_food', 'name': '餐饮', 'type': 'expense', 'icon': '🍔', 'color': '#FF6B6B'},
      {'id': 'exp_transport', 'name': '交通', 'type': 'expense', 'icon': '🚌', 'color': '#4ECDC4'},
      {'id': 'exp_shopping', 'name': '购物', 'type': 'expense', 'icon': '🛍️', 'color': '#45B7D1'},
      {'id': 'exp_entertainment', 'name': '娱乐', 'type': 'expense', 'icon': '🎮', 'color': '#96CEB4'},
      {'id': 'exp_housing', 'name': '居住', 'type': 'expense', 'icon': '🏠', 'color': '#FFEAA7'},
      {'id': 'exp_medical', 'name': '医疗', 'type': 'expense', 'icon': '💊', 'color': '#DDA0DD'},
      {'id': 'exp_education', 'name': '教育', 'type': 'expense', 'icon': '📚', 'color': '#98D8C8'},
      {'id': 'exp_other', 'name': '其他', 'type': 'expense', 'icon': '📦', 'color': '#F7DC6F'},
      // Income categories
      {'id': 'inc_salary', 'name': '工资', 'type': 'income', 'icon': '💰', 'color': '#2ECC71'},
      {'id': 'inc_bonus', 'name': '奖金', 'type': 'income', 'icon': '🎁', 'color': '#27AE60'},
      {'id': 'inc_investment', 'name': '投资', 'type': 'income', 'icon': '📈', 'color': '#16A085'},
      {'id': 'inc_other', 'name': '其他', 'type': 'income', 'icon': '💵', 'color': '#1ABC9C'},
    ];

    for (var category in defaultCategories) {
      await db.insert('categories', {
        ...category,
        'isDefault': 1,
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades
  }

  // Transaction operations
  Future<String> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    
    var data = transaction.toJson();
    
    // Encrypt sensitive data if enabled
    if (transaction.isEncrypted) {
      data['note'] = await _securityUtils.encrypt(transaction.note ?? '');
    }
    
    await db.insert('transactions', data);
    return transaction.id;
  }

  Future<List<List<TransactionModel>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    String? accountType,
  }) async {
    final db = await database;
    
    var whereClause = '';
    var whereArgs = <dynamic>[];
    
    if (startDate != null) {
      whereClause += 'timestamp >= ?';
      whereArgs.add(startDate.toIso8601String());
    }
    
    if (endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'timestamp <= ?';
      whereArgs.add(endDate.toIso8601String());
    }
    
    if (categoryId != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'categoryId = ?';
      whereArgs.add(categoryId);
    }
    
    if (accountType != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'accountType = ?';
      whereArgs.add(accountType);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'timestamp DESC',
    );

    return Future.wait(maps.map((map) async {
      var data = Map<String, dynamic>.from(map);
      
      // Decrypt if needed
      if (data['isEncrypted'] == 1 && data['note'] != null) {
        data['note'] = await _securityUtils.decrypt(data['note']);
      }
      
      return TransactionModel.fromJson(data);
    }).toList());
  }

  Future<Map<String, double>> getMonthlyStats(int year, int month) async {
    final db = await database;
    
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0);
    
    final result = await db.rawQuery('''
      SELECT 
        SUM(CASE WHEN c.type = 'expense' THEN amount ELSE 0 END) as totalExpense,
        SUM(CASE WHEN c.type = 'income' THEN amount ELSE 0 END) as totalIncome
      FROM transactions t
      JOIN categories c ON t.categoryId = c.id
      WHERE t.timestamp >= ? AND t.timestamp <= ?
    ''', [startDate.toIso8601String(), endDate.toIso8601String()]);
    
    return {
      'expense': result.first['totalExpense'] as double? ?? 0.0,
      'income': result.first['totalIncome'] as double? ?? 0.0,
    };
  }

  // Journal operations
  Future<String> insertJournal(JournalModel journal) async {
    final db = await database;
    
    var data = journal.toJson();
    
    if (journal.isEncrypted) {
      data['content'] = await _securityUtils.encrypt(journal.content);
    }
    
    await db.insert('journals', data);
    return journal.id;
  }

  Future<List<List<JournalModel>> getJournals({
    DateTime? startDate,
    DateTime? endDate,
    int? moodId,
  }) async {
    final db = await database;
    
    var whereClause = '';
    var whereArgs = <dynamic>[];
    
    if (startDate != null) {
      whereClause += 'createdAt >= ?';
      whereArgs.add(startDate.toIso8601String());
    }
    
    if (endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'createdAt <= ?';
      whereArgs.add(endDate.toIso8601String());
    }
    
    if (moodId != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'moodId = ?';
      whereArgs.add(moodId);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'journals',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'createdAt DESC',
    );

    return Future.wait(maps.map((map) async {
      var data = Map<String, dynamic>.from(map);
      
      if (data['isEncrypted'] == 1) {
        data['content'] = await _securityUtils.decrypt(data['content']);
      }
      
      return JournalModel.fromJson(data);
    }).toList());
  }

  // Task operations
  Future<String> insertTask(TaskModel task) async {
    final db = await database;
    await db.insert('tasks', task.toJson());
    return task.id;
  }

  Future<List<TaskModel>> getTasks({
    bool? isCompleted,
    DateTime? dueDate,
    int? priority,
  }) async {
    final db = await database;
    
    var whereClause = '';
    var whereArgs = <dynamic>[];
    
    if (isCompleted != null) {
      whereClause += 'isCompleted = ?';
      whereArgs.add(isCompleted ? 1 : 0);
    }
    
    if (dueDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'date(dueTime) = date(?)';
      whereArgs.add(dueDate.toIso8601String());
    }
    
    if (priority != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'priority = ?';
      whereArgs.add(priority);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'dueTime ASC, priority DESC',
    );

    return maps.map((map) => TaskModel.fromJson(map)).toList();
  }

  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    final db = await database;
    await db.update(
      'tasks',
      {
        'isCompleted': isCompleted ? 1 : 0,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  // Category operations
  Future<List<List<CategoryModel>> getCategories(String type) async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'isDefault DESC, name ASC',
    );

    return maps.map((map) => CategoryModel.fromJson(map)).toList();
  }

  // Settings operations
  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (maps.isNotEmpty) {
      return maps.first['value'] as String;
    }
    return null;
  }

  // Backup and restore
  Future<Map<String, dynamic>> exportData() async {
    final db = await database;
    
    return {
      'transactions': await db.query('transactions'),
      'journals': await db.query('journals'),
      'tasks': await db.query('tasks'),
      'categories': await db.query('categories'),
      'settings': await db.query('settings'),
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  Future<void> importData(Map<String, dynamic> data) async {
    final db = await database;
    
    await db.transaction((txn) async {
      // Clear existing data
      await txn.delete('transactions');
      await txn.delete('journals');
      await txn.delete('tasks');
      await txn.delete('categories');
      await txn.delete('settings');
      
      // Import new data
      for (var item in data['transactions'] ?? []) {
        await txn.insert('transactions', item);
      }
      for (var item in data['journals'] ?? []) {
        await txn.insert('journals', item);
      }
      for (var item in data['tasks'] ?? []) {
        await txn.insert('tasks', item);
      }
      for (var item in data['categories'] ?? []) {
        await txn.insert('categories', item);
      }
      for (var item in data['settings'] ?? []) {
        await txn.insert('settings', item);
      }
    });
  }

  // Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
