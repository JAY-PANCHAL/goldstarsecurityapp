import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/constants/api_constants.dart';
import 'package:golstarsecurityapplatest/app/routes/app_routes.dart';
import 'package:golstarsecurityapplatest/core/services/session_manager.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isAuthFree = ApiConstants.isAuthFreeEndpoint(options.path);
    final isRefresh = ApiConstants.isRefreshEndpoint(options.path);
    if (isAuthFree || isRefresh) {
      handler.next(options);
      return;
    }
    if (options.headers.containsKey('Authorization')) {
      handler.next(options);
      return;
    }

    final token = await SessionManager.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await SessionManager.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final dio = Dio(
            BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              headers: const {'Accept': 'application/json'},
            ),
          );
          final response = await dio.get(
            ApiConstants.refreshAuthentication,
            options: Options(
              headers: {'Authorization': 'Bearer $refreshToken'},
            ),
          );

          final newAccessToken = response.data.toString().replaceAll('"', '');
          await SessionManager.updateAccessToken(newAccessToken);

          err.requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';
          final retryResponse = await dio.fetch(err.requestOptions);
          handler.resolve(retryResponse);
          return;
        } catch (_) {
          await SessionManager.clearSession();
          Get.offAllNamed(AppRoutes.login);
        }
      } else {
        await SessionManager.clearSession();
        Get.offAllNamed(AppRoutes.login);
      }
    }
    handler.next(err);
  }
}
