import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/routes/app_routes.dart';
import 'package:golstarsecurityapplatest/core/database/db_helper.dart';
import 'package:golstarsecurityapplatest/core/services/session_manager.dart';
import 'package:golstarsecurityapplatest/core/services/sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final SyncService syncService;

  HomeController({required this.syncService});

  final RxString lastSyncText = 'Never'.obs;
  final RxString role = 'guard'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLastSync();
  }

  Future<void> _loadLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('last_sync');
    if (value != null && value.isNotEmpty) {
      lastSyncText.value = value;
    }
  }

  Future<void> refreshData() async {
    await syncService.sync();
    await _loadLastSync();
  }

  Future<void> logout() async {
    await SessionManager.clearSession();
    await DbHelper.clearAll();
    Get.offAllNamed(AppRoutes.login);
  }

  void openRoundoff() {
    Get.toNamed(AppRoutes.roundoffLanding);
  }

  void openVerification() {
    Get.toNamed(AppRoutes.verificationLanding);
  }

  void openAdmin() {
    if (role.value == 'admin') {
      Get.toNamed(AppRoutes.adminDashboard);
    }
  }
}
