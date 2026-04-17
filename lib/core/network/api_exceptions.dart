import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  /// Extracts the most meaningful message from the API response data.
  /// Handles plain strings, JSON objects with 'message'/'error'/'title' keys,
  /// and falls back to a status-code-based default.
  static String _extractMessage(dynamic data, int? code) {
    if (data == null) return _fallback(code);

    // Plain string response
    if (data is String) {
      final cleaned = data.replaceAll('"', '').trim();
      return cleaned.isNotEmpty ? cleaned : _fallback(code);
    }

    // JSON object — try common message keys
    if (data is Map) {
      for (final key in ['message', 'Message', 'error', 'Error', 'title', 'Title', 'detail', 'Detail']) {
        final val = data[key];
        if (val is String && val.trim().isNotEmpty) return val.trim();
      }
      // Nested errors array (validation responses)
      final errors = data['errors'] ?? data['Errors'];
      if (errors is Map) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
      }
    }

    return _fallback(code);
  }

  static String _fallback(int? code) {
    switch (code) {
      case 400: return 'Invalid request. Please check your input.';
      case 401: return 'Session expired. Please login again.';
      case 403: return 'You are not authorised to perform this action.';
      case 404: return 'Resource not found.';
      case 408: return 'Request timed out. Try again.';
      case 409: return 'Conflict — record may already exist.';
      case 413: return 'File is too large to upload.';
      case 415: return 'File format not supported. Use JPG, PNG, or PDF.';
      case 422: return 'Validation failed. Check your input.';
      case 429: return 'Too many requests. Please wait and try again.';
      case 500: return 'Internal server error. Please try later.';
      case 502: return 'Server is unreachable. Try again later.';
      case 503: return 'Service unavailable. Try again later.';
      default:  return 'Something went wrong (code: $code).';
    }
  }

  factory ApiException.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout. Check your internet.',
          statusCode: 408,
        );
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        final msg  = _extractMessage(e.response?.data, code);
        return ApiException(message: msg, statusCode: code);
      case DioExceptionType.connectionError:
        return ApiException(message: 'No internet connection.', statusCode: 0);
      default:
        return ApiException(
          message: e.message?.isNotEmpty == true
              ? e.message!
              : 'Something went wrong.',
          statusCode: -1,
        );
    }
  }
}
