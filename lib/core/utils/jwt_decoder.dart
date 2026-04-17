import 'dart:convert';

class JwtDecoder {
  static Map<String, dynamic>? decode(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    final payload = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(payload));
    final map = json.decode(decoded) as Map<String, dynamic>;
    return map;
  }
}
