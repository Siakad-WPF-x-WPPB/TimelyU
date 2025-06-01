import 'package:get/get.dart';
import 'package:timelyu/data/datasources/database_helper.dart';
import 'package:timelyu/data/models/task_model.dart';

class TaskService extends GetxService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<TaskModel>> getAllTasks() async {
    return _databaseHelper.getAllTasks();
  }

  Future<List<TaskModel>> getTasksByFilter(String filter) async {
    return _databaseHelper.getTasksByFilter(filter);
  }

  Future<void> addTask(TaskModel task) async {
    await _databaseHelper.insertTask(task);
  }

  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {
    await _databaseHelper.toggleTaskCompletion(id, isCompleted);
  }

  Future<void> deleteTask(String id) async {
    await _databaseHelper.deleteTask(id);
  }

   Future<void> updateTask(TaskModel task) async {
    await _databaseHelper.updateTask(task);
  }

  Future<List<TaskModel>> getTaskUpcoming({int limit = 5}) async {
    final allTasks = await _databaseHelper.getAllTasks();

    // filter task jika belum selesai dan terlambat
    List<TaskModel> filteredTasks = allTasks.where((task) {
      return task.status == 'Belum Selesai' || task.status == 'Terlambat';
    }).toList();

    filteredTasks.sort((a, b){
      try {
        DateTime dateA = a.parsedDateTime;
        DateTime dateB = b.parsedDateTime;
        return dateA.compareTo(dateB);
      } catch (e) {
        // Jika parsing gagal, anggap kedua tanggal sama
        return 0;
      }
    });
    return filteredTasks.take(limit).toList();
  }
}