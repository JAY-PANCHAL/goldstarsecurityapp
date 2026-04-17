import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/features/admin/data/datasources/admin_local_datasource.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminLocalDatasource());
  }
}
