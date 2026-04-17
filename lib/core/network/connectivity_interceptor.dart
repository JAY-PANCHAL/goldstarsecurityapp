import 'package:dio/dio.dart';
import 'package:golstarsecurityapplatest/core/services/connectivity_service.dart';
import 'package:golstarsecurityapplatest/core/network/api_exceptions.dart';

class ConnectivityInterceptor extends Interceptor {
  final ConnectivityService _connectivityService;

  ConnectivityInterceptor(this._connectivityService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!_connectivityService.isOnline) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: ApiException(message: 'No internet connection', statusCode: 0),
        ),
      );
      return;
    }
    handler.next(options);
  }
}
