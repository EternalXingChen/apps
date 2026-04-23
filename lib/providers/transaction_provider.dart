import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../services/database_service.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  
  List List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _error;
  
  double _totalIncome = 0;
  double _totalExpense = 0;

  List List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get balance => _totalIncome - _totalExpense;

  Future<void> loadTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _transactions = await _db.getTransactions(
        startDate: startDate,
        endDate: endDate,
        categoryId: categoryId,
      );
      _calculateTotals();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateTotals() {
    _totalIncome = _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0, (sum, t) => sum + t.amount);
    
    _totalExpense = _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _db.insertTransaction(transaction);
      await loadTransactions();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      final db = await _db.database;
      await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
      await loadTransactions();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      final db = await _db.database;
      await db.update(
        'transactions',
        transaction.toJson(),
        where: 'id = ?',
        whereArgs: [transaction.id],
      );
      await loadTransactions();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  List List<TransactionModel> getTransactionsForDate(DateTime date) {
    return _transactions.where((t) {
      return t.timestamp.year == date.year &&
             t.timestamp.month == date.month &&
             t.timestamp.day == date.day;
    }).toList();
  }

  Map<String, double> getCategoryTotals() {
    final Map<String, double> totals = {};
    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.expense) {
        totals[transaction.categoryId] = (totals[transaction.categoryId] ?? 0) + transaction.amount;
      }
    }
    return totals;
  }

  Future<Map<String, double>> getMonthlyStats(int year, int month) async {
    return await _db.getMonthlyStats(year, month);
  }
}
