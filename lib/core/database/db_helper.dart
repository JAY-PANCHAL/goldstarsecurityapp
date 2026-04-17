import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:golstarsecurityapplatest/core/database/tables/buildings_table.dart';
import 'package:golstarsecurityapplatest/core/database/tables/checkpoints_table.dart';
import 'package:golstarsecurityapplatest/core/database/tables/employees_table.dart';
import 'package:golstarsecurityapplatest/core/database/tables/floors_table.dart';
import 'package:golstarsecurityapplatest/core/database/tables/roundoff_checkpoints_table.dart';
import 'package:golstarsecurityapplatest/core/database/tables/roundoff_schedule_table.dart';
import 'package:golstarsecurityapplatest/core/database/tables/security_team_table.dart';
import 'package:golstarsecurityapplatest/core/database/tables/verifications_table.dart';

class DbHelper {
  static const String _dbName = 'goldstar_security.db';
  static const int _dbVersion = 1;

  static Database? _database;

  static Future<Database> instance() async {
    if (_database != null) return _database!;
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);

    _database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute(EmployeesTable.create);
        await db.execute(VerificationsTable.create);
        await db.execute(RoundoffScheduleTable.create);
        await db.execute(RoundoffCheckpointsTable.create);
        await db.execute(BuildingsTable.create);
        await db.execute(FloorsTable.create);
        await db.execute(CheckpointsTable.create);
        await db.execute(SecurityTeamTable.create);
      },
    );

    return _database!;
  }

  static Future<void> clearAll() async {
    final db = await instance();
    await db.delete(EmployeesTable.tableName);
    await db.delete(VerificationsTable.tableName);
    await db.delete(RoundoffScheduleTable.tableName);
    await db.delete(RoundoffCheckpointsTable.tableName);
    await db.delete(BuildingsTable.tableName);
    await db.delete(FloorsTable.tableName);
    await db.delete(CheckpointsTable.tableName);
    await db.delete(SecurityTeamTable.tableName);
  }
}
