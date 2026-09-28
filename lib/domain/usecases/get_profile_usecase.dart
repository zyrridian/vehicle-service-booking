import '../entities/profile_entity.dart';
import '../repositories/account_repository.dart';

class GetProfileUseCase {
  final AccountRepository repository;
  GetProfileUseCase(this.repository);

  Future<ProfileEntity> execute() {
    return repository.getProfile();
  }
}
