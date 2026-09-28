import '../entities/address_entity.dart';
import '../entities/profile_entity.dart';

abstract class AccountRepository {
  Future<ProfileEntity> getProfile();
  Future<ProfileEntity> updateProfile(ProfileEntity profile);
  Future<List<AddressEntity>> getAddresses();
  Future<AddressEntity> addAddress(AddressEntity address);
  Future<AddressEntity> updateAddress(AddressEntity address);
}
