import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/routes/app_routes.dart';
import 'package:golstarsecurityapplatest/core/services/session_manager.dart';
import 'package:golstarsecurityapplatest/core/services/sync_service.dart';
import 'package:golstarsecurityapplatest/features/auth/domain/usecases/refresh_token_usecase.dart';

class SplashController extends GetxController {
  final RefreshTokenUsecase refreshTokenUsecase;
  final SyncService syncService;

  SplashController({
    required this.refreshTokenUsecase,
    required this.syncService,
  });

  final RxBool isSyncing = true.obs;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final accessToken = await SessionManager.getAccessToken();
    final refreshToken = await SessionManager.getRefreshToken();

    Future<void> flow() async {
      if (accessToken == null || accessToken.isEmpty) {
        Get.offAllNamed(AppRoutes.login);
        return;
      }

      if (SessionManager.isAccessTokenExpired(accessToken)) {
        if (refreshToken == null || refreshToken.isEmpty) {
          await SessionManager.clearSession();
          Get.offAllNamed(AppRoutes.login);
          return;
        }

        try {
          final newToken = await refreshTokenUsecase(refreshToken);
          await SessionManager.updateAccessToken(newToken);
        } catch (_) {
          await SessionManager.clearSession();
          Get.offAllNamed(AppRoutes.login);
          return;
        }
      }

      await syncService.sync();
      Get.offAllNamed(AppRoutes.landing);
    }

    try {
      await Future.any([
        flow(),
        Future.delayed(const Duration(seconds: 10), () => throw 'timeout'),
      ]);
    } catch (_) {
      if (accessToken != null && accessToken.isNotEmpty) {
        Get.offAllNamed(AppRoutes.landing);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } finally {
      isSyncing.value = false;
    }
  }
}
