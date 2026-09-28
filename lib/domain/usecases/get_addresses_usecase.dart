import '../entities/address_entity.dart';
import '../repositories/account_repository.dart';

class GetAddressesUseCase {
  final AccountRepository repository;
  GetAddressesUseCase(this.repository);

  Future<List<AddressEntity>> execute() {
    return repository.getAddresses();
  }
}
