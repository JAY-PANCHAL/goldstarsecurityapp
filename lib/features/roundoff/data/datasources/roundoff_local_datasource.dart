import 'package:golstarsecurityapplatest/core/database/db_helper.dart';
import 'package:golstarsecurityapplatest/core/database/tables/roundoff_checkpoints_table.dart';
import 'package:golstarsecurityapplatest/core/database/tables/roundoff_schedule_table.dart';
import 'package:golstarsecurityapplatest/features/roundoff/data/models/roundoff_schedule_model.dart';

class RoundoffLocalDatasource {
  Future<List<RoundoffScheduleModel>> getSchedules() async {
    // TODO: Replace with real API when available
    final db = await DbHelper.instance();
    final rows = await db.query(
      RoundoffScheduleTable.tableName,
      orderBy: 'rDate DESC',
    );
    return rows.map(RoundoffScheduleModel.fromDb).toList();
  }

  Future<void> updateScheduleStatus(
    String code,
    String status, {
    String? start,
    String? end,
    int? scanned,
  }) async {
    // TODO: Replace with real API when available
    final db = await DbHelper.instance();
    final data = <String, dynamic>{'status': status};
    if (start != null) data['startDateTime'] = start;
    if (end != null) data['endDateTime'] = end;
    if (scanned != null) data['scannedCPCount'] = scanned;
    await db.update(
      RoundoffScheduleTable.tableName,
      data,
      where: 'code = ?',
      whereArgs: [code],
    );
  }

  Future<void> addCheckpointScan(
    String roundoffCode,
    String cpCode,
    String dateTime,
  ) async {
    // TODO: Replace with real API when available
    final db = await DbHelper.instance();
    await db.insert(RoundoffCheckpointsTable.tableName, {
      'roundoffCode': roundoffCode,
      'cpCode': cpCode,
      'cpScanDateTime': dateTime,
      'status': 'Completed',
    });
  }

  Future<bool> isCheckpointScanned(String roundoffCode, String cpCode) async {
    // TODO: Replace with real API when available
    final db = await DbHelper.instance();
    final rows = await db.query(
      RoundoffCheckpointsTable.tableName,
      where: 'roundoffCode = ? AND cpCode = ?',
      whereArgs: [roundoffCode, cpCode],
    );
    return rows.isNotEmpty;
  }
}
