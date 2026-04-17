import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/constants/api_constants.dart';
import 'package:golstarsecurityapplatest/core/network/api_client.dart';
import 'package:http_parser/http_parser.dart';

/// Holds both the server message and the HTTP status code so callers
/// can build accurate user-facing feedback.
class VerificationResult {
  final String message;
  final int statusCode;

  const VerificationResult({required this.message, required this.statusCode});

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

abstract class VerificationRemoteDatasource {
  Future<VerificationResult> submitVerification({
    required int employeeId,
    required String status,
    required File pdfFile,
  });
}

class VerificationRemoteDatasourceImpl implements VerificationRemoteDatasource {
  final dio.Dio _dio = Get.find<ApiClient>().dio;

  @override
  Future<VerificationResult> submitVerification({
    required int employeeId,
    required String status,
    required File pdfFile,
  }) async {
    final formData = dio.FormData.fromMap({
      'EmployeeId': employeeId.toString(),
      'Status': status,
      'File': await dio.MultipartFile.fromFile(
        pdfFile.path,
        filename:
            'verification_${employeeId}_${DateTime.now().millisecondsSinceEpoch}.pdf',
        contentType: MediaType('application', 'pdf'),
      ),
    });

    final response = await _dio.post(
      ApiConstants.sendEmpVerification,
      data: formData,
    );

    final code = response.statusCode ?? 200;
    // Extract the plaintext message the server returned
    final raw = response.data;
    String message;
    if (raw is String) {
      message = raw.replaceAll('"', '').trim();
    } else if (raw is Map) {
      message = (raw['message'] ?? raw['Message'] ?? raw['title'] ?? raw['Title'] ?? '').toString().trim();
    } else {
      message = raw?.toString().replaceAll('"', '').trim() ?? '';
    }
    if (message.isEmpty) {
      message = status == 'Verified'
          ? 'Employee verified successfully.'
          : 'Employee marked as rejected.';
    }

    return VerificationResult(message: message, statusCode: code);
  }
}
