import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/data/models/task_model.dart';
import 'package:timelyu/data/services/task_service.dart';

class TaskController extends GetxController {
  final TaskService _taskService;

  TaskController(this._taskService);

  final RxString selectedFilter = 'Semua'.obs;
  final RxList<TaskModel> filteredTasks = <TaskModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    updateFilteredTasks();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    updateFilteredTasks();
  }

  Future<void> updateFilteredTasks() async {
    isLoading.value = true;
    try {
      final tasks = await _taskService.getTasksByFilter(selectedFilter.value);
      filteredTasks.assignAll(tasks);
    } catch (e) {
      // Handle error, e.g., show a snackbar
      Get.snackbar('Error', 'Failed to load tasks: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {
    try {
      await _taskService.toggleTaskCompletion(id, isCompleted);
      await updateFilteredTasks(); // Refresh list after update
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await _taskService.addTask(task);
      setFilter('Semua'); // Optionally reset filter or go to the filter that shows new task
    } catch (e) {
      Get.snackbar('Error', 'Failed to add task: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  
  Future<void> updateTask(TaskModel task) async { // Added for completeness
    try {
      await _taskService.updateTask(task);
      await updateFilteredTasks();
    } catch (e) {
       Get.snackbar('Error', 'Failed to update task: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _taskService.deleteTask(id);
      await updateFilteredTasks(); // Refresh list after deleting
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete task: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // UI helper method for status badge colors
  Map<String, Color> getStatusColors(String status) {
    switch (status) {
      case 'Selesai':
        return {
          'background': Colors.green[100]!,
          'text': Colors.green[800]!,
        };
      case 'Terlambat':
        return {
          'background': Colors.red[100]!,
          'text': Colors.red[800]!,
        };
      case 'Belum Selesai':
        return {
          'background': Colors.orange[100]!,
          'text': Colors.orange[800]!,
        };
      default:
        return {
          'background': Colors.grey[100]!,
          'text': Colors.grey[800]!,
        };
    }
  }
}