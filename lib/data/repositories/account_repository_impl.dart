import '../../domain/entities/address_entity.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/local/account_local_datasource.dart';
import '../datasources/remote/account_remote_datasource.dart';
import '../models/profile_model.dart';
import '../models/address_model.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;
  final AccountLocalDataSource localDataSource;

  AccountRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<ProfileEntity> getProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();
      await localDataSource.cacheProfile(profile);
      return profile;
    } catch (e) {
      final cached = await localDataSource.getCachedProfile();
      if (cached != null) return cached;
      throw Exception('Failed to load profile');
    }
  }

  @override
  Future<ProfileEntity> updateProfile(ProfileEntity profile) async {
    final updatedProfile = await remoteDataSource.updateProfile(ProfileModel.fromEntity(profile));
    await localDataSource.cacheProfile(updatedProfile);
    return updatedProfile;
  }

  @override
  Future<List<AddressEntity>> getAddresses() async {
    return await remoteDataSource.getAddresses();
  }

  @override
  Future<AddressEntity> addAddress(AddressEntity address) async {
    return await remoteDataSource.addAddress(AddressModel(
      id: address.id,
      label: address.label,
      fullAddress: address.fullAddress,
      isDefault: address.isDefault,
    ));
  }

  @override
  Future<AddressEntity> updateAddress(AddressEntity address) async {
    return await remoteDataSource.updateAddress(AddressModel(
      id: address.id,
      label: address.label,
      fullAddress: address.fullAddress,
      isDefault: address.isDefault,
    ));
  }
}
