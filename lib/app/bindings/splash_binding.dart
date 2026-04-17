import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/core/services/sync_service.dart';
import 'package:golstarsecurityapplatest/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:golstarsecurityapplatest/features/splash/presentation/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SplashController(
        refreshTokenUsecase: Get.find<RefreshTokenUsecase>(),
        syncService: Get.find<SyncService>(),
      ),
    );
  }
}
