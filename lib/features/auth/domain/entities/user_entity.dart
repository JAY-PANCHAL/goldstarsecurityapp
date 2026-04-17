class UserEntity {
  final String accessToken;
  final String refreshToken;
  final int employeeId;

  UserEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.employeeId,
  });
}
