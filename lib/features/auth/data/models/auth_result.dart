class AuthResult {
  final bool isSuccess;
  final String? errorMessage;
  final String? userId;

  AuthResult({
    required this.isSuccess,
    this.errorMessage,
    this.userId,
  });

  factory AuthResult.success({String? userId}) {
    return AuthResult(
      isSuccess: true,
      userId: userId,
    );
  }

  factory AuthResult.failure(String errorMessage) {
    return AuthResult(
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }
}