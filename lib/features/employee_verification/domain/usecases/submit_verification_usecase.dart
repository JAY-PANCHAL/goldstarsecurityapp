import 'dart:io';

import 'package:golstarsecurityapplatest/features/employee_verification/data/datasources/verification_remote_datasource.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/repositories/verification_repository.dart';

class SubmitVerificationUsecase {
  final VerificationRepository repository;

  SubmitVerificationUsecase(this.repository);

  Future<VerificationResult> call({
    required int employeeId,
    required String status,
    required File pdfFile,
  }) {
    return repository.submitVerification(
      employeeId: employeeId,
      status: status,
      pdfFile: pdfFile,
    );
  }
}
