import 'dart:io';

import 'package:golstarsecurityapplatest/app/constants/api_constants.dart';

class FileUtils {
  static Future<int> fileSize(File file) async => file.length();

  static bool isAllowedFormat(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ApiConstants.allowedFileFormats.contains(ext);
  }
}
