import '../entities/address_entity.dart';
import '../repositories/account_repository.dart';

class AddAddressUseCase {
  final AccountRepository repository;
  AddAddressUseCase(this.repository);

  Future<AddressEntity> execute(AddressEntity address) {
    return repository.addAddress(address);
  }
}
