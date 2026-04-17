import 'package:dio/dio.dart';
import 'package:golstarsecurityapplatest/app/constants/api_constants.dart';
import 'package:golstarsecurityapplatest/core/network/api_client.dart';
import 'package:golstarsecurityapplatest/features/auth/data/models/login_request_model.dart';
import 'package:golstarsecurityapplatest/features/auth/data/models/login_response_model.dart';
import 'package:get/get.dart';

abstract class AuthRemoteDatasource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<String> refreshAccessToken(String refreshToken);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio _dio = Get.find<ApiClient>().dio;

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await _dio.post(
      ApiConstants.setAuthentication,
      data: request.toJson(),
    );
    return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<String> refreshAccessToken(String refreshToken) async {
    final response = await _dio.get(
      ApiConstants.refreshAuthentication,
      options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
    );
    return response.data.toString().replaceAll('"', '');
  }
}
