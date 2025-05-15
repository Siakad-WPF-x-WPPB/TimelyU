import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/data/models/task_model.dart';
import 'task_controller.dart';

class TaskScreen extends GetView<TaskController> {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: const Text(
            'Tugas',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
        ),
        elevation: 0,
        // backgroundColor: Colors.white,
        // foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          children: [_buildFilterSection(), Expanded(child: _buildTaskList())],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to add new task
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2, // Index for Tasks tab
        onTap: (index) {
          // Handle navigation to other tabs
          // This would typically use Get.toNamed() to navigate to other screens
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, color: Colors.blue),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Semua'),
            const SizedBox(width: 8),
            _buildFilterChip('Selesai'),
            const SizedBox(width: 8),
            _buildFilterChip('Belum Selesai'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return GetX<TaskController>(
      builder: (ctrl) {
        bool isSelected = ctrl.selectedFilter.value == label;
        return GestureDetector(
          onTap: () {
            controller.setFilter(label);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskList() {
    return GetX<TaskController>(
      builder:
          (ctrl) =>
              ctrl.filteredTasks.isEmpty
                  ? const Center(
                    child: Text(
                      'Tidak ada tugas tersedia',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                  : ListView.builder(
                    itemCount: ctrl.filteredTasks.length,
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      final task = ctrl.filteredTasks[index];
                      return _buildTaskItem(task);
                    },
                  ),
    );
  }

  Widget _buildTaskItem(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: CheckboxListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task.description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                ),
                _buildStatusBadge(task.status),
              ],
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Text(
                task.date,
                style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
              ),
              const SizedBox(width: 8),
              Text(
                task.time,
                style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
              ),
            ],
          ),
        ),
        value: task.isDone,
        onChanged: (value) {
          if (value != null) {
            controller.toggleTaskCompletion(task.id, value);
          }
        },
        controlAffinity: ListTileControlAffinity.leading,
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final colors = controller.getStatusColors(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: colors['background'],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: colors['text'],
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
