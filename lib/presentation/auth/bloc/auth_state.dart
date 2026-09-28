import '../../../domain/entities/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final String phone;
  AuthLoginSuccess(this.phone);
}

class AuthOtpSuccess extends AuthState {
  final UserEntity user;
  AuthOtpSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
