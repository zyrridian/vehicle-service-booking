import 'dart:convert';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> login(String phone);
  Future<UserModel> verifyOtp(String phone, String otp);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<void> login(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    if (phone.isEmpty) {
      throw Exception('Phone number cannot be empty');
    }
  }

  @override
  Future<UserModel> verifyOtp(String phone, String otp) async {
    await Future.delayed(const Duration(seconds: 1));

    if (otp != '123456') {
      throw Exception('Invalid verification code');
    }

    const jsonResponse = '''
    {
      "id": "USR-99812",
      "name": "Dimas Pratama",
      "phone": "+6281234567890",
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy_token"
    }
    ''';

    final Map<String, dynamic> decoded = jsonDecode(jsonResponse);
    return UserModel.fromJson(decoded);
  }
}
