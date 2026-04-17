import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/core/services/sync_service.dart';
import 'package:golstarsecurityapplatest/features/auth/domain/repositories/auth_repository.dart';
import 'package:golstarsecurityapplatest/features/auth/domain/usecases/login_usecase.dart';
import 'package:golstarsecurityapplatest/features/auth/presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginUsecase(Get.find<AuthRepository>()));
    Get.lazyPut(
      () => AuthController(
        loginUsecase: Get.find<LoginUsecase>(),
        syncService: Get.find<SyncService>(),
      ),
      fenix: true,
    );
  }
}
