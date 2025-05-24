// lib/controllers/task_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/data/models/task_model.dart';
import 'package:timelyu/data/services/task_service.dart';

class TaskController extends GetxController {
  final TaskService _taskService = Get.find<TaskService>();
  
  // State variables
  final RxString selectedFilter = 'Semua'.obs;
  final RxList<TaskModel> filteredTasks = <TaskModel>[].obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize task list
    updateFilteredTasks();
  }
  
  // Update filter selection and refresh task list
  void setFilter(String filter) {
    selectedFilter.value = filter;
    updateFilteredTasks();
  }
  
  // Update filtered tasks based on selected filter
  Future<void> updateFilteredTasks() async {
    isLoading.value = true;
    try {
      final tasks = await _taskService.getTasksByFilter(selectedFilter.value);
      filteredTasks.assignAll(tasks);
    } finally {
      isLoading.value = false;
    }
  }
  
  // Toggle task completion status
  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {
    await _taskService.toggleTaskCompletion(id, isCompleted);
    await updateFilteredTasks(); // Refresh list after update
  }
  
  // Add a new task
  Future<void> addTask(TaskModel task) async {
    await _taskService.addTask(task);
    await updateFilteredTasks(); // Refresh list after adding
  }
  
  // Delete a task
  Future<void> deleteTask(String id) async {
    await _taskService.deleteTask(id);
    await updateFilteredTasks(); // Refresh list after deleting
  }
  
  // Get color configuration for status badge
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