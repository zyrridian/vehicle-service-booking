import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<void> execute(String phone) {
    return repository.login(phone);
  }
}
