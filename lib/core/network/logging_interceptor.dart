import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[API] ${options.method} ${options.uri}');
      if (options.data != null) {
        final data = options.data;
        if (data is FormData) {
          final fields = data.fields
              .map((e) => '${e.key}=${e.value}')
              .join(', ');
          final files = data.files
              .map((e) => '${e.key}=${e.value.filename ?? 'file'}')
              .join(', ');
          debugPrint('[API] REQUEST_FORM_FIELDS $fields');
          debugPrint('[API] REQUEST_FORM_FILES $files');
        } else {
          debugPrint('[API] REQUEST_DATA ${_stringify(data)}');
        }
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[API] ${response.statusCode} ${response.requestOptions.uri}');
      if (response.data != null) {
        debugPrint('[API] RESPONSE_DATA ${_stringify(response.data)}');
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '[API] ERROR ${err.requestOptions.uri} '
        'type=${err.type} '
        'status=${err.response?.statusCode} '
        'message=${err.message} '
        'error=${err.error}',
      );
      if (err.response?.data != null) {
        debugPrint('[API] ERROR_DATA ${_stringify(err.response!.data)}');
      }
    }
    handler.next(err);
  }

  String _stringify(dynamic data) {
    try {
      if (data is String) return data;
      return jsonEncode(data);
    } catch (_) {
      return data.toString();
    }
  }
}
