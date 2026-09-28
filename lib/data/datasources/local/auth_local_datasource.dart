import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheSession(UserModel user);
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> cacheSession(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> clearSession() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
