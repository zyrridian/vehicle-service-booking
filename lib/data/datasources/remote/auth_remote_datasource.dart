import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_client.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> login(String phone);
  Future<UserModel> verifyOtp(String phone, String otp);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<void> login(String phone) async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Future<UserModel> verifyOtp(String phone, String otp) async {
    final responseData = await _client.post(
      ApiEndpoints.verifyOtp,
      data: {
        "phone": phone,
        "otp": otp,
      },
    );
    return UserModel.fromJson(responseData);
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
