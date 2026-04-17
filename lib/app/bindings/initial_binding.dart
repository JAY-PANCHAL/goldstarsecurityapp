import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/core/network/api_client.dart';
import 'package:golstarsecurityapplatest/core/services/connectivity_service.dart';
import 'package:golstarsecurityapplatest/core/services/notification_service.dart';
import 'package:golstarsecurityapplatest/core/services/sync_service.dart';
import 'package:golstarsecurityapplatest/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:golstarsecurityapplatest/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:golstarsecurityapplatest/features/auth/domain/repositories/auth_repository.dart';
import 'package:golstarsecurityapplatest/features/auth/domain/usecases/refresh_token_usecase.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final connectivity = Get.put(ConnectivityService(), permanent: true);
    connectivity.init();
    final notifications = Get.put(NotificationService(), permanent: true);
    notifications.init();
    Get.lazyPut(() => SyncService(), fenix: true);

    Get.lazyPut<ApiClient>(
      () => ApiClient(Get.find<ConnectivityService>()),
      fenix: true,
    );

    Get.lazyPut<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(),
      fenix: true,
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(remote: Get.find()),
      fenix: true,
    );
    Get.lazyPut(
      () => RefreshTokenUsecase(Get.find<AuthRepository>()),
      fenix: true,
    );
  }
}
