import 'package:golstarsecurityapplatest/features/auth/domain/repositories/auth_repository.dart';

class RefreshTokenUsecase {
  final AuthRepository repository;

  RefreshTokenUsecase(this.repository);

  Future<String> call(String refreshToken) {
    return repository.refreshToken(refreshToken);
  }
}
