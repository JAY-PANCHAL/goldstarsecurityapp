import 'package:golstarsecurityapplatest/core/database/db_helper.dart';
import 'package:golstarsecurityapplatest/core/database/tables/employees_table.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/models/employee_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class EmployeeLocalDatasource {
  Future<void> upsertEmployees(List<EmployeeModel> employees);
  Future<List<EmployeeModel>> getPendingEmployees();
  Future<List<Map<String, dynamic>>> getVerifiedEmployees();
  Future<void> markVerified(int employeeId, String verifiedAt);
}

class EmployeeLocalDatasourceImpl implements EmployeeLocalDatasource {
  @override
  Future<void> upsertEmployees(List<EmployeeModel> employees) async {
    final db = await DbHelper.instance();
    final batch = db.batch();
    for (final emp in employees) {
      batch.insert(
        EmployeesTable.tableName,
        emp.toDbMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<EmployeeModel>> getPendingEmployees() async {
    final db = await DbHelper.instance();
    final rows = await db.query(
      EmployeesTable.tableName,
      where: 'isVerified = 0',
      orderBy: 'empName ASC',
    );
    return rows.map(EmployeeModel.fromDb).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getVerifiedEmployees() async {
    final db = await DbHelper.instance();
    return db.query(
      EmployeesTable.tableName,
      where: 'isVerified = 1',
      orderBy: 'verificationDateTime DESC',
    );
  }

  @override
  Future<void> markVerified(int employeeId, String verifiedAt) async {
    final db = await DbHelper.instance();
    await db.update(
      EmployeesTable.tableName,
      {'isVerified': 1, 'verificationDateTime': verifiedAt},
      where: 'employeeId = ?',
      whereArgs: [employeeId],
    );
  }
}
