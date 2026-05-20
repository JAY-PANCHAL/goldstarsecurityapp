import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
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

    // Allow self-signed certificates from the API server.
    // TODO: Replace with a proper CA-signed certificate on the server side.
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
      ConnectivityInterceptor(connectivityService),
    ]);
  }
}
