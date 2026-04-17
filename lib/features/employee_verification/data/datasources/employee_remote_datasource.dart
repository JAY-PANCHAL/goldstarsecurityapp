import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/constants/api_constants.dart';
import 'package:golstarsecurityapplatest/core/network/api_client.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/models/employee_model.dart';

abstract class EmployeeRemoteDatasource {
  Future<List<EmployeeModel>> fetchEmployees();
}

class EmployeeRemoteDatasourceImpl implements EmployeeRemoteDatasource {
  final Dio _dio = Get.find<ApiClient>().dio;

  @override
  Future<List<EmployeeModel>> fetchEmployees() async {
    final response = await _dio.get(ApiConstants.getEmpList);
    final data = response.data as List<dynamic>;
    return data
        .map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
