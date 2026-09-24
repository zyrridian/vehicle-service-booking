/// Environment configuration wrapper.
/// Use this class to manage varying environmental configurations (e.g., dev, staging, prod).
abstract class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.default-env.com',
  );

  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}
