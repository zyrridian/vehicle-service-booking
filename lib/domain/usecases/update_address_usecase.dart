import '../entities/address_entity.dart';
import '../repositories/account_repository.dart';

class UpdateAddressUseCase {
  final AccountRepository repository;
  UpdateAddressUseCase(this.repository);

  Future<AddressEntity> execute(AddressEntity address) {
    return repository.updateAddress(address);
  }
}
