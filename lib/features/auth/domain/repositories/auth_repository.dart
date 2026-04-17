import 'package:golstarsecurityapplatest/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String username, String password);
  Future<String> refreshToken(String refreshToken);
}
