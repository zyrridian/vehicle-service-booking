import '../entities/profile_entity.dart';
import '../repositories/account_repository.dart';

class UpdateProfileUseCase {
  final AccountRepository repository;
  UpdateProfileUseCase(this.repository);

  Future<ProfileEntity> execute(ProfileEntity profile) {
    return repository.updateProfile(profile);
  }
}
