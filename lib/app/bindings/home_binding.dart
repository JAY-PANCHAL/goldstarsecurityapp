import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/core/services/sync_service.dart';
import 'package:golstarsecurityapplatest/features/home/presentation/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(syncService: Get.find<SyncService>()),
      fenix: true,
    );
  }
}
