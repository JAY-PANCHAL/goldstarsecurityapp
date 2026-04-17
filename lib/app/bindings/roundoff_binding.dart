import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/features/roundoff/data/datasources/roundoff_local_datasource.dart';
import 'package:golstarsecurityapplatest/features/roundoff/presentation/controllers/roundoff_activity_controller.dart';
import 'package:golstarsecurityapplatest/features/roundoff/presentation/controllers/roundoff_list_controller.dart';

class RoundoffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RoundoffLocalDatasource());
    Get.lazyPut(
      () => RoundoffListController(localDatasource: Get.find()),
      fenix: true,
    );
    Get.lazyPut(
      () => RoundoffActivityController(localDatasource: Get.find()),
      fenix: true,
    );
  }
}
