import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> login(String phone);
  Future<UserEntity> verifyOtp(String phone, String otp);
}
