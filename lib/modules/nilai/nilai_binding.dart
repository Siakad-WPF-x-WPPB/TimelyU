import 'package:get/get.dart';
import 'package:timelyu/modules/nilai/nilai_controller.dart';


class NilaiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NilaiController>(
      () => NilaiController(),
    );
  }
}