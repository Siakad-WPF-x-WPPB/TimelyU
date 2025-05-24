// lib/data/services/task_service.dart
import 'package:get/get.dart';
import 'package:timelyu/data/datasources/database_helper.dart';
import 'package:timelyu/data/models/task_model.dart';

class TaskService extends GetxService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  
  // Get all tasks
  Future<List<TaskModel>> getAllTasks() async {
    return await _databaseHelper.getAllTasks();
  }

  // Get tasks by filter
  Future<List<TaskModel>> getTasksByFilter(String filter) async {
    return await _databaseHelper.getTasksByFilter(filter);
  }

  // Add a new task
  Future<void> addTask(TaskModel task) async {
    await _databaseHelper.insertTask(task);
  }

  // Toggle task completion status
  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {
    await _databaseHelper.toggleTaskCompletion(id, isCompleted);
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    await _databaseHelper.deleteTask(id);
  }
}