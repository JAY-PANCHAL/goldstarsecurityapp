import 'dart:io';

import 'package:dio/dio.dart';
import 'package:golstarsecurityapplatest/core/network/api_exceptions.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/datasources/verification_remote_datasource.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/repositories/verification_repository.dart';

class VerificationRepositoryImpl implements VerificationRepository {
  final VerificationRemoteDatasource remote;

  VerificationRepositoryImpl({required this.remote});

  @override
  Future<VerificationResult> submitVerification({
    required int employeeId,
    required String status,
    required File pdfFile,
  }) async {
    try {
      return await remote.submitVerification(
        employeeId: employeeId,
        status: status,
        pdfFile: pdfFile,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
