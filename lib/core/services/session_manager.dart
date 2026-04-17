import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:golstarsecurityapplatest/core/utils/jwt_decoder.dart';

class SessionManager {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _employeeIdKey = 'employee_id';
  static const _loginTimestampKey = 'login_timestamp';

  static const _storage = FlutterSecureStorage();

  static Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required int employeeId,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _employeeIdKey, value: employeeId.toString());

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loginTimestampKey, DateTime.now().toIso8601String());
  }

  static Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  static Future<int?> getEmployeeId() async {
    final value = await _storage.read(key: _employeeIdKey);
    return value == null ? null : int.tryParse(value);
  }

  static Future<void> updateAccessToken(String accessToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
  }

  static Future<void> clearSession() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _employeeIdKey);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginTimestampKey);
  }

  static int? extractEmployeeId(String jwt) {
    final payload = JwtDecoder.decode(jwt);
    if (payload == null) return null;
    return int.tryParse(payload['unique_name']?.toString() ?? '');
  }

  static bool isAccessTokenExpired(String jwt) {
    final payload = JwtDecoder.decode(jwt);
    if (payload == null) return true;
    final exp = payload['exp'] as int?;
    if (exp == null) return true;
    return DateTime.fromMillisecondsSinceEpoch(
      exp * 1000,
    ).subtract(const Duration(minutes: 2)).isBefore(DateTime.now());
  }
}
