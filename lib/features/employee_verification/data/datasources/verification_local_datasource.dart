import 'package:golstarsecurityapplatest/core/database/db_helper.dart';
import 'package:golstarsecurityapplatest/core/database/tables/verifications_table.dart';

class VerificationLocalDatasource {
  Future<void> addPending({
    required int employeeId,
    required String status,
    required String pdfPath,
    String? rejectionReason,
  }) async {
    final db = await DbHelper.instance();
    await db.insert(VerificationsTable.tableName, {
      'employeeId': employeeId,
      'status': status,
      'rejectionReason': rejectionReason,
      'pdfPath': pdfPath,
      'createdAt': DateTime.now().toIso8601String(),
      'syncStatus': 'pending',
    });
  }

  Future<List<Map<String, dynamic>>> getPending() async {
    final db = await DbHelper.instance();
    return db.query(
      VerificationsTable.tableName,
      where: 'syncStatus = ?',
      whereArgs: ['pending'],
    );
  }

  Future<void> markSynced(int id) async {
    final db = await DbHelper.instance();
    await db.update(
      VerificationsTable.tableName,
      {'syncStatus': 'synced'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
