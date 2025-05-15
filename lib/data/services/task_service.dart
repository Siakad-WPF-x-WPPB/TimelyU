import 'package:get/get.dart';
import 'package:timelyu/data/models/task_model.dart';

class TaskService extends GetxService {
  // Mock data untuk tampilan awal
  final RxList<TaskModel> tasks = <TaskModel>[
    TaskModel(
      id: '1',
      title: 'Kecerdasan Buatan',
      description: 'Monitoring Button',
      status: 'Selesai',
      date: '23 May 2022', time: '12.00',
    ),
    TaskModel(
      id: '2',
      title: 'Workshop Permrograman Framework',
      description: 'Monitoring Button',
      status: 'Terlambat',
      date: '2 April 2022', time: '12:00',
    ),
    TaskModel(
      id: '3',
      title: 'Workshop Mobile Programming',
      description: 'Monitoring Button',
      status: 'Hari ini',
      date: '15 May 2025', time: '12:00',
    ),
  ].obs;

  // Mendapatkan semua tugas
  List<TaskModel> getAllTasks() {
    return tasks;
  }

  // Mendapatkan tugas dengan filter
  List<TaskModel> getTasksByFilter(String filter) {
    if (filter == 'Semua') {
      return tasks;
    } else if (filter == 'Terlambat') {
      return tasks.where((task) => task.status== 'Terlambat').toList();
    } else if (filter == 'Belum Selesai') {
      return tasks.where((task) => !task.isDone).toList();
    }
    return tasks;
  }

  // Menambah tugas baru
  void addTask(TaskModel task) {
    tasks.add(task);
  }

  // Menandai tugas sebagai selesai/belum
  void toggleTaskCompletion(String id, bool isCompleted) {
    final index = tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      tasks[index].isDone = isCompleted;
      tasks.refresh();
    }
  }

  // Menghapus tugas
  void deleteTask(String id) {
    tasks.removeWhere((task) => task.id == id);
  }
}