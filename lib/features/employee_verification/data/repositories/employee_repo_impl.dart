import 'package:dio/dio.dart';
import 'package:golstarsecurityapplatest/core/network/api_exceptions.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/datasources/employee_local_datasource.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/datasources/employee_remote_datasource.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/entities/employee_entity.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDatasource remote;
  final EmployeeLocalDatasource local;

  EmployeeRepositoryImpl({required this.remote, required this.local});

  @override
  Future<List<EmployeeEntity>> fetchAndCacheEmployees() async {
    try {
      final employees = await remote.fetchEmployees();
      return employees
          .map(
            (e) => EmployeeEntity(
              employeeId: e.employeeId,
              empCode: e.empCode,
              empName: e.empName,
              status: e.status,
              verifiedDate: e.verifiedDate,
              createdDate: e.createdDate,
              isReferenceMandatory: e.isReferenceMandatory,
              verificationDate: e.verificationDate,
              verificationTimeSlot: e.verificationTimeSlot,
              mobileNo: e.mobileNo,
              altMobileNo: e.altMobileNo,
              emailOfficial: e.emailOfficial,
              emailPersonal: e.emailPersonal,
              add1: e.add1,
              add2: e.add2,
              city: e.city,
              state: e.state,
              pin: e.pin,
              aadhar: e.aadhar,
              gender: e.gender,
              pan: e.pan,
              age: e.age,
              homeType: e.homeType,
              spouseName: e.spouseName,
              fatherName: e.fatherName,
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<List<EmployeeEntity>> getPendingEmployees() async {
    final list = await remote.fetchEmployees();
    return list
        .where((e) => (e.status ?? '').toLowerCase() != 'verified')
        .map(
          (e) => EmployeeEntity(
            employeeId: e.employeeId,
            empCode: e.empCode,
            empName: e.empName,
            status: e.status,
            verifiedDate: e.verifiedDate,
            createdDate: e.createdDate,
            isReferenceMandatory: e.isReferenceMandatory,
            verificationDate: e.verificationDate,
            verificationTimeSlot: e.verificationTimeSlot,
            mobileNo: e.mobileNo,
            altMobileNo: e.altMobileNo,
            emailOfficial: e.emailOfficial,
            emailPersonal: e.emailPersonal,
            add1: e.add1,
            add2: e.add2,
            city: e.city,
            state: e.state,
            pin: e.pin,
            aadhar: e.aadhar,
            gender: e.gender,
            pan: e.pan,
            age: e.age,
            homeType: e.homeType,
            spouseName: e.spouseName,
            fatherName: e.fatherName,
          ),
        )
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getVerifiedEmployees() async {
    final list = await remote.fetchEmployees();
    return list
        .where((e) => (e.status ?? '').toLowerCase() == 'verified')
        .map(
          (e) => <String, dynamic>{
            'employeeId': e.employeeId,
            'empCode': e.empCode,
            'empName': e.empName,
            'createdDate': e.createdDate ?? '',
            'mobileNo': e.mobileNo,
            'city': e.city,
            'verificationDateTime': e.verifiedDate ?? '',
          },
        )
        .toList();
  }

  @override
  Future<void> markVerified(int employeeId, String verifiedAt) {
    return Future.value();
  }
}
