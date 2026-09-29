import '../repositories/account_repository.dart';

class DeleteAddressUseCase {
  final AccountRepository repository;

  DeleteAddressUseCase(this.repository);

  Future<void> execute(String addressId) async {
    return await repository.deleteAddress(addressId);
  }
}
