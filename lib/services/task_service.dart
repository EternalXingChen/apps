import '../models/task_model.dart';
import 'database_service.dart';

class TaskService {
  static final DatabaseService _db = DatabaseService();

  static Future<void> createTask(TaskModel task) async {
    await _db.insertTask(task);
  }

  static Future<void> updateTask(TaskModel task) async {
    final db = await _db.database;
    await db.update('tasks', task.toJson(), where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<void> deleteTask(String taskId) async {
    final db = await _db.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
  }

  static Future<List<TaskModel>> getTasks() async {
    return await _db.getTasks();
  }
}
