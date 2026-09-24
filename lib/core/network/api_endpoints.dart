/// Defines all remote endpoints to prevent hardcoded strings throughout the data layer.
abstract class ApiEndpoints {
  static const String authLogin = '/v1/auth/login';
  static const String authRegister = '/v1/auth/register';
  static const String userProfile = '/v1/user/profile';
}
