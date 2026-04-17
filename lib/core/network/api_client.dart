import 'package:dio/dio.dart';
import 'package:golstarsecurityapplatest/app/constants/api_constants.dart';
import 'package:golstarsecurityapplatest/core/network/auth_interceptor.dart';
import 'package:golstarsecurityapplatest/core/network/connectivity_interceptor.dart';
import 'package:golstarsecurityapplatest/core/network/logging_interceptor.dart';
import 'package:golstarsecurityapplatest/core/services/connectivity_service.dart';

class ApiClient {
  late final Dio dio;

  ApiClient(ConnectivityService connectivityService) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
      ConnectivityInterceptor(connectivityService),
    ]);
  }
}
