import '../../models/user_model.dart';

/// Defines the remote operations necessary for authentication.
abstract class AuthRemoteDataSource {
  /// Authenticates a user and returns their profile representation.
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> login({required String email, required String password});
}
