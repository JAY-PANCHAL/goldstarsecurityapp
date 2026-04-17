import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/datasources/employee_local_datasource.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/datasources/employee_remote_datasource.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/datasources/verification_local_datasource.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/datasources/verification_remote_datasource.dart';

class SyncService extends GetxService {
  Future<void> sync() async {
    // TODO: Replace with full sync orchestration when more APIs are available.
    await _pushPendingVerifications();
    await _pullEmployees();
    await _setLastSync();
  }

  Future<void> _pushPendingVerifications() async {
    final local = VerificationLocalDatasource();
    final remote = VerificationRemoteDatasourceImpl();

    final pending = await local.getPending();
    for (final item in pending) {
      final id = item['id'] as int;
      final employeeId = item['employeeId'] as int;
      final status = item['status'] as String;
      final pdfPath = item['pdfPath'] as String;
      final file = File(pdfPath);
      if (!await file.exists()) continue;

      try {
        await remote.submitVerification(
          employeeId: employeeId,
          status: status,
          pdfFile: file,
        );
        await local.markSynced(id);
      } catch (_) {
        // keep pending
      }
    }
  }

  Future<void> _pullEmployees() async {
    final remote = EmployeeRemoteDatasourceImpl();
    final local = EmployeeLocalDatasourceImpl();
    try {
      final employees = await remote.fetchEmployees();
      await local.upsertEmployees(employees);
    } catch (_) {
      // ignore if offline
    }
  }

  Future<void> _setLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    await prefs.setString('last_sync', now);
  }
}
