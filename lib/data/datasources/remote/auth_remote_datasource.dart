import 'dart:convert';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> login(String phone);
  Future<UserModel> verifyOtp(String phone, String otp);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<void> login(String phone) async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Future<UserModel> verifyOtp(String phone, String otp) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (otp == '123456') {
      const jsonResponse = '''
      {
        "id": "USR-12345",
        "name": "Dimas Pratama",
        "phone": "+62 812 3456 7890",
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
      }
      ''';
      return UserModel.fromJson(jsonDecode(jsonResponse));
    }
    throw Exception('Invalid OTP Code');
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
