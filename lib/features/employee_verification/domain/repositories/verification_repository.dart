import 'dart:io';

import 'package:golstarsecurityapplatest/features/employee_verification/data/datasources/verification_remote_datasource.dart';

abstract class VerificationRepository {
  Future<VerificationResult> submitVerification({
    required int employeeId,
    required String status,
    required File pdfFile,
  });
}
