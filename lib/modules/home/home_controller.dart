import 'package:get/get.dart';
import 'package:timelyu/data/models/task_model.dart';
import 'package:timelyu/data/services/task_service.dart';

class HomeController extends GetxController {
  final TaskService _taskService = Get.find<TaskService>();

  final RxList<TaskModel> upcomingTasks = <TaskModel>[].obs;
  final RxBool isLoadingUpcomingTasks = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingTasks();
  }

  Future<void> fetchUpcomingTasks() async {
    try {
      isLoadingUpcomingTasks.value = true;
      // Ambil misal 5 tugas mendatang/terlambat
      final tasks = await _taskService.getTaskUpcoming(limit: 5);
      upcomingTasks.assignAll(tasks);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat tugas mendatang: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingUpcomingTasks.value = false;
    }
  }
}