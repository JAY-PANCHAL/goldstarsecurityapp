import 'package:golstarsecurityapplatest/features/employee_verification/domain/entities/employee_entity.dart';

abstract class EmployeeRepository {
  Future<List<EmployeeEntity>> fetchAndCacheEmployees();
  Future<List<EmployeeEntity>> getPendingEmployees();
  Future<List<Map<String, dynamic>>> getVerifiedEmployees();
  Future<void> markVerified(int employeeId, String verifiedAt);
}
