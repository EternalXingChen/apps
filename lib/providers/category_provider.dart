import 'package:flutter/foundation.dart';
import '../models/category_model.dart';
import '../services/database_service.dart';

class CategoryProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  
  List<CategoryModel> _expenseCategories = [];
  List<CategoryModel> _incomeCategories = [];
  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get expenseCategories => _expenseCategories;
  List<CategoryModel> get incomeCategories => _incomeCategories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _expenseCategories = await _db.getCategories('expense');
      _incomeCategories = await _db.getCategories('income');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    try {
      final db = await _db.database;
      await db.insert('categories', category.toJson());
      await loadCategories();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateCategory(CategoryModel category) async {
    try {
      final db = await _db.database;
      await db.update(
        'categories',
        category.toJson(),
        where: 'id = ?',
        whereArgs: [category.id],
      );
      await loadCategories();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      final db = await _db.database;
      await db.delete('categories', where: 'id = ?', whereArgs: [id]);
      await loadCategories();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  CategoryModel? getCategoryById(String id) {
    try {
      return [..._expenseCategories, ..._incomeCategories]
          .firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  String getCategoryName(String id) {
    final category = getCategoryById(id);
    return category?.name ?? '未知分类';
  }

  String getCategoryIcon(String id) {
    final category = getCategoryById(id);
    return category?.icon ?? '📦';
  }
}
