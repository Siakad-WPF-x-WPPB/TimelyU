// lib/views/task_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/task/add_task.dart';
import 'package:timelyu/modules/task/task_controller.dart';
import 'package:timelyu/shared/widgets/bottomNavigasi.dart';

class TaskView extends GetView<TaskController> {
  const TaskView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Tugas',
          style: TextStyle(
            color: Colors.black,
            fontSize: isDesktop ? 26 : isTablet ? 24 : 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive padding
            double horizontalPadding = screenWidth * 0.04;
            if (isDesktop) {
              horizontalPadding = screenWidth * 0.15; // Center content on desktop
            } else if (isTablet) {
              horizontalPadding = screenWidth * 0.08;
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  SizedBox(height: isTablet ? 24 : 16),
                  _buildFilterSection(controller, context),
                  SizedBox(height: isTablet ? 24 : 16),
                  Expanded(child: _buildTaskList(controller, context)),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: _buildAddTaskButton(context),
      bottomNavigationBar: const TaskBottomNavigationBar(),
    );
  }

  Widget _buildFilterSection(TaskController controller, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('Semua', controller, context),
          SizedBox(width: isDesktop ? 16 : isTablet ? 12 : 8),
          _buildFilterChip('Terlambat', controller, context),
          SizedBox(width: isDesktop ? 16 : isTablet ? 12 : 8),
          _buildFilterChip('Belum Selesai', controller, context),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String filter,
    TaskController controller,
    BuildContext context,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return Obx(() {
      final isSelected = controller.selectedFilter.value == filter;

      Color getChipColor() {
        if (filter == 'Semua') return const Color(0xFF2196F3);
        if (filter == 'Terlambat') return const Color(0xFFFF5722);
        if (filter == 'Belum Selesai') return const Color(0xFF9C27B0);
        return const Color(0xFF2196F3);
      }

      return Container(
        height: isDesktop ? 40 : isTablet ? 36 : 32,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 24 : isTablet ? 20 : 16,
        ),
        decoration: BoxDecoration(
          color: isSelected ? getChipColor() : Colors.grey[100],
          borderRadius: BorderRadius.circular(
            isDesktop ? 20 : isTablet ? 18 : 16,
          ),
        ),
        child: Center(
          child: GestureDetector(
            onTap: () => controller.setFilter(filter),
            child: Text(
              filter,
              style: TextStyle(
                fontSize: isDesktop ? 16 : isTablet ? 15 : 14,
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTaskList(TaskController controller, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredTasks.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.task_alt,
                size: isDesktop ? 80 : isTablet ? 72 : 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: isTablet ? 24 : 16),
              Text(
                'Tidak ada tugas',
                style: TextStyle(
                  fontSize: isDesktop ? 24 : isTablet ? 20 : 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 100 : isTablet ? 60 : 40,
                ),
                child: Text(
                  'Tambahkan tugas baru dengan menekan tombol +',
                  style: TextStyle(
                    fontSize: isDesktop ? 16 : isTablet ? 15 : 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }

      // For desktop, use GridView with multiple columns
      if (isDesktop) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 12,
            childAspectRatio: 3.5,
          ),
          itemCount: controller.filteredTasks.length,
          itemBuilder: (context, index) {
            final task = controller.filteredTasks[index];
            return _buildTaskCard(task, controller, context);
          },
        );
      }

      // For mobile and tablet, use ListView
      return ListView.builder(
        itemCount: controller.filteredTasks.length,
        itemBuilder: (context, index) {
          final task = controller.filteredTasks[index];
          return _buildTaskCard(task, controller, context);
        },
      );
    });
  }

  Widget _buildTaskCard(dynamic task, TaskController controller, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    Color getStatusColor() {
      switch (task.status) {
        case 'Terlambat':
          return const Color(0xFFFF5722);
        case 'Selesai':
          return const Color(0xFF4CAF50);
        case 'Belum Selesai':
          return const Color(0xFF9C27B0);
        default:
          return const Color(0xFF2196F3);
      }
    }

    return Container(
      margin: EdgeInsets.only(
        bottom: isDesktop ? 16 : isTablet ? 14 : 12,
      ),
      child: Card(
        shadowColor: Colors.grey[300],
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isDesktop ? 16 : isTablet ? 14 : 12,
          ),
          side: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(
            isDesktop ? 16 : isTablet ? 14 : 12,
          ),
          onLongPress: () => _showDeleteDialog(context, task.id),
          child: Padding(
            padding: EdgeInsets.all(
              isDesktop ? 20 : isTablet ? 18 : 16,
            ),
            child: Row(
              children: [
                // Checkbox
                GestureDetector(
                  onTap: () {
                    controller.toggleTaskCompletion(task.id, !task.isDone);
                  },
                  child: Container(
                    width: isDesktop ? 28 : isTablet ? 26 : 24,
                    height: isDesktop ? 28 : isTablet ? 26 : 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: task.isDone ? const Color(0xFF4CAF50) : Colors.grey[400]!,
                        width: 2,
                      ),
                      color: task.isDone ? const Color(0xFF4CAF50) : Colors.transparent,
                    ),
                    child: task.isDone
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: isDesktop ? 18 : isTablet ? 17 : 16,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: isDesktop ? 16 : isTablet ? 14 : 12),
                
                // Task content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: isDesktop ? 18 : isTablet ? 17 : 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          decoration: task.isDone ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: isDesktop ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isTablet ? 6 : 4),
                      Text(
                        task.description,
                        style: TextStyle(
                          fontSize: isDesktop ? 16 : isTablet ? 15 : 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: isDesktop ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isDesktop ? 12 : isTablet ? 10 : 8),
                      
                      // Date and time info
                      if (isDesktop) 
                        Row(
                          children: [
                            _buildInfoRow(Icons.calendar_today, task.date, context),
                            const SizedBox(width: 24),
                            _buildInfoRow(Icons.access_time, task.time, context),
                          ],
                        )
                      else
                        Wrap(
                          spacing: isTablet ? 20 : 16,
                          children: [
                            _buildInfoRow(Icons.calendar_today, task.date, context),
                            _buildInfoRow(Icons.access_time, task.time, context),
                          ],
                        ),
                    ],
                  ),
                ),
                
                SizedBox(width: isDesktop ? 16 : isTablet ? 14 : 12),
                
                // Status badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 12 : isTablet ? 10 : 8,
                    vertical: isDesktop ? 6 : isTablet ? 5 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(),
                    borderRadius: BorderRadius.circular(
                      isDesktop ? 14 : isTablet ? 13 : 12,
                    ),
                  ),
                  child: Text(
                    task.status,
                    style: TextStyle(
                      fontSize: isDesktop ? 14 : isTablet ? 13 : 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: isDesktop ? 16 : isTablet ? 15 : 14,
          color: Colors.grey[600],
        ),
        SizedBox(width: isTablet ? 6 : 4),
        Text(
          text,
          style: TextStyle(
            fontSize: isDesktop ? 14 : isTablet ? 13 : 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, String taskId) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isDesktop ? 20 : isTablet ? 18 : 16,
          ),
        ),
        title: Text(
          'Hapus Tugas',
          style: TextStyle(
            fontSize: isDesktop ? 22 : isTablet ? 20 : 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus tugas ini?',
          style: TextStyle(
            fontSize: isDesktop ? 16 : isTablet ? 15 : 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Batal',
              style: TextStyle(
                fontSize: isDesktop ? 16 : isTablet ? 15 : 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.deleteTask(taskId);
              Navigator.of(context).pop();
            },
            child: Text(
              'Hapus',
              style: TextStyle(
                color: Colors.red,
                fontSize: isDesktop ? 16 : isTablet ? 15 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return FloatingActionButton(
      onPressed: () => Get.to(() => AddTaskScreen()),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          isDesktop ? 36 : isTablet ? 34 : 32,
        ),
      ),
      backgroundColor: const Color(0xFF00509D),
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: isDesktop ? 36.0 : isTablet ? 34.0 : 30.0,
      ),
    );
  }
}