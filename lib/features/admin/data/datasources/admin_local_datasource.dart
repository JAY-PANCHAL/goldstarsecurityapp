import 'package:golstarsecurityapplatest/core/database/db_helper.dart';
import 'package:golstarsecurityapplatest/core/database/tables/buildings_table.dart';
import 'package:golstarsecurityapplatest/core/database/tables/checkpoints_table.dart';
import 'package:golstarsecurityapplatest/core/database/tables/floors_table.dart';
import 'package:golstarsecurityapplatest/core/database/tables/roundoff_schedule_table.dart';
import 'package:golstarsecurityapplatest/core/database/tables/security_team_table.dart';

class AdminLocalDatasource {
  Future<List<Map<String, dynamic>>> getSecurityTeam() async {
    // TODO: Replace with real API when available
    final db = await DbHelper.instance();
    return db.query(SecurityTeamTable.tableName, orderBy: 'name ASC');
  }

  Future<void> addSecurityTeam(Map<String, dynamic> data) async {
    // TODO: Replace with real API when available
    final db = await DbHelper.instance();
    await db.insert(SecurityTeamTable.tableName, data);
  }

  Future<List<Map<String, dynamic>>> getBuildings() async {
    // TODO: Replace with real API when available
    final db = await DbHelper.instance();
    return db.query(BuildingsTable.tableName, orderBy: 'name ASC');
  }

  Future<void> addBuilding(Map<String, dynamic> data) async {
    // TODO: Replace with real API when available
    final db = await DbHelper.instance();
    await db.insert(BuildingsTable.tableName, data);
  }

  Future<List<Map<String, dynamic>>> getFloors() async {
    // TODO: Replace with real API when available
    final db = await DbHelper.instance();
    return db.query(FloorsTable.tableName, orderBy: 'name ASC');
  }

  Future<void> addFloor(Map<String, dynamic> data) async {
    // TODO: Replace with real API when available
    final db = await DbHelper.instance();
    await db.insert(FloorsTable.tableName, data);
  }

  Future<List<Map<String, dynamic>>> getCheckpoints() async {
    // TODO: Replace with real API when available
    final db = await DbHelper.instance();
    return db.query(CheckpointsTable.tableName, orderBy: 'name ASC');
  }

  Future<void> addCheckpoint(Map<String, dynamic> data) async {
    // TODO: Replace with real API when available
    final db = await DbHelper.instance();
    await db.insert(CheckpointsTable.tableName, data);
  }

  Future<List<Map<String, dynamic>>> getSchedules() async {
    // TODO: Replace with real API when available
    final db = await DbHelper.instance();
    return db.query(RoundoffScheduleTable.tableName, orderBy: 'rDate DESC');
  }

  Future<void> addSchedule(Map<String, dynamic> data) async {
    // TODO: Replace with real API when available
    final db = await DbHelper.instance();
    await db.insert(RoundoffScheduleTable.tableName, data);
  }
}
