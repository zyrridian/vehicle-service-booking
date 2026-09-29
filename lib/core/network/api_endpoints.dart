/// Defines all remote endpoints to prevent hardcoded strings throughout the data layer.
abstract class ApiEndpoints {
  static const String baseUrl = 'https://servisinaja-api.vercel.app';
  static const String verifyOtp = '/api/auth/verify-otp';
  static const String userProfile = '/api/account/profile';
  static const String addresses = '/api/account/addresses';
  static const String garageVehicles = '/api/garage/vehicles';
  static const String workshops = '/api/workshops';
  static const String bookings = '/api/bookings';
  static const String tracking = '/api/tracking';
  static const String invoices = '/api/invoices';
  static const String reviews = '/api/reviews';
  static const String history = '/api/history';
}
