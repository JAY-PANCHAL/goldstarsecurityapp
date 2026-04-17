import 'package:golstarsecurityapplatest/features/employee_verification/domain/entities/employee_entity.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/repositories/employee_repository.dart';

class GetEmployeesUsecase {
  final EmployeeRepository repository;

  GetEmployeesUsecase(this.repository);

  Future<List<EmployeeEntity>> fetchAndCache() =>
      repository.fetchAndCacheEmployees();
  Future<List<EmployeeEntity>> getPending() => repository.getPendingEmployees();
  Future<List<Map<String, dynamic>>> getVerified() =>
      repository.getVerifiedEmployees();
}
