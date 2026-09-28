import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheSession(UserModel user);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> cacheSession(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
