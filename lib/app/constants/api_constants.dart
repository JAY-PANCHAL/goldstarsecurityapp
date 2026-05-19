class ApiConstants {
  static const String baseUrl =
      'https://accordapi.goldstarjewellery.com/webAPI/api';

  // Auth
  static const String setAuthentication = '/setAuthentication';
  static const String refreshAuthentication = '/refreshAuthentication';

  // Employee Verification
  static const String getEmpList = '/getEmpList';
  static const String sendEmpVerification = '/sendEmpVerification';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 60);

  // File constraints
  static const int maxFileSize = 5 * 1024 * 1024;
  static const List<String> allowedFileFormats = ['jpg', 'jpeg', 'png', 'pdf'];

  static bool isAuthFreeEndpoint(String path) {
    if (path.contains(setAuthentication)) return true;
    return false;
  }

  static bool isRefreshEndpoint(String path) {
    return path.contains(refreshAuthentication);
  }
}
