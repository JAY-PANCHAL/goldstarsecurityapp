import 'package:flutter/services.dart';

class PublicDownloadsExporter {
  static const MethodChannel _channel =
      MethodChannel('com.mindtech.goldstarsecurity/public_downloads');

  /// Returns a content URI string when saved via MediaStore, or null on failure.
  static Future<String?> savePdfToPublicDownloads({
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final uri = await _channel.invokeMethod<String>(
        'savePdf',
        <String, dynamic>{
          'bytes': bytes,
          'fileName': fileName,
        },
      );
      return uri;
    } catch (_) {
      return null;
    }
  }
}
