abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String phone;
  LoginRequested(this.phone);
}

class VerifyOtpRequested extends AuthEvent {
  final String phone;
  final String otp;
  VerifyOtpRequested(this.phone, this.otp);
}
