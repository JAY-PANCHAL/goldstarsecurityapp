import 'package:dio/dio.dart';
import 'package:golstarsecurityapplatest/core/network/api_exceptions.dart';
import 'package:golstarsecurityapplatest/core/services/session_manager.dart';
import 'package:golstarsecurityapplatest/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:golstarsecurityapplatest/features/auth/data/models/login_request_model.dart';
import 'package:golstarsecurityapplatest/features/auth/domain/entities/user_entity.dart';
import 'package:golstarsecurityapplatest/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;

  AuthRepositoryImpl({required this.remote});

  @override
  Future<UserEntity> login(String username, String password) async {
    try {
      final request = LoginRequestModel(username: username, password: password);
      final response = await remote.login(request);
      final employeeId = SessionManager.extractEmployeeId(response.accessToken);
      if (employeeId == null) {
        throw ApiException(message: 'Invalid token received', statusCode: 0);
      }
      return UserEntity(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        employeeId: employeeId,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    try {
      return await remote.refreshAccessToken(refreshToken);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
