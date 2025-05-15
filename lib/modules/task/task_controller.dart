import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/data/models/task_model.dart';
import 'package:timelyu/data/services/task_service.dart';

class TaskController extends GetxController {
  final TaskService _taskService = Get.find<TaskService>();
  
  // State variables
  final RxString selectedFilter = 'Semua'.obs;
  final RxList<TaskModel> filteredTasks = <TaskModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    // Inisialisasi daftar tugas
    updateFilteredTasks();
  }
  
  // Update filter selection and refresh task list
  void setFilter(String filter) {
    selectedFilter.value = filter;
    updateFilteredTasks();
  }
  
  // Update filtered tasks based on selected filter
  void updateFilteredTasks() {
    filteredTasks.assignAll(_taskService.getTasksByFilter(selectedFilter.value));
  }
  
  // Toggle task completion status
  void toggleTaskCompletion(String id, bool isCompleted) {
    _taskService.toggleTaskCompletion(id, isCompleted);
    updateFilteredTasks(); // Refresh list after update
  }
  
  // Add a new task
  void addTask(TaskModel task) {
    _taskService.addTask(task);
    updateFilteredTasks(); // Refresh list after adding
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
      case 'Hari ini':
        return {
          'background': Colors.purple[100]!,
          'text': Colors.purple[800]!,
        };
      default:
        return {
          'background': Colors.grey[100]!,
          'text': Colors.grey[800]!,
        };
    }
  }
}