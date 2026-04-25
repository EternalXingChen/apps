import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';

class TaskProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  
  List<TaskModel> _tasks = [];
  List<TaskModel> _pendingTasks = [];
  List<TaskModel> _completedTasks = [];
  bool _isLoading = false;
  String? _error;

  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get pendingTasks => _pendingTasks;
  List<TaskModel> get completedTasks => _completedTasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _db.getTasks();
      _pendingTasks = _tasks.where((t) => !t.isCompleted).toList();
      _completedTasks = _tasks.where((t) => t.isCompleted).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await _db.insertTask(task);
      await loadTasks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleTaskComplete(String taskId) async {
    try {
      final task = _tasks.firstWhere((t) => t.id == taskId);
      await _db.updateTaskCompletion(taskId, !task.isCompleted);
      await loadTasks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final db = await _db.database;
      await db.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
      await loadTasks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      final db = await _db.database;
      await db.update('tasks', task.toJson(), where: 'id = ?', whereArgs: [task.id]);
      await loadTasks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  List<TaskModel> getTasksForDate(DateTime date) {
    return _tasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.year == date.year &&
             task.dueDate!.month == date.month &&
             task.dueDate!.day == date.day;
    }).toList();
  }

  List<TaskModel> getOverdueTasks() {
    final now = DateTime.now();
    return _pendingTasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.isBefore(now);
    }).toList();
  }

  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      final db = await _db.database;
      final result = await db.query('tasks', where: 'id = ?', whereArgs: [taskId]);
      if (result.isNotEmpty) {
        return TaskModel.fromJson(result.first);
      }
      return null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
