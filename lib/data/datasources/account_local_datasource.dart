import '../models/profile_model.dart';

abstract class AccountLocalDataSource {
  Future<void> cacheProfile(ProfileModel profile);
  Future<ProfileModel?> getCachedProfile();
}

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  ProfileModel? _cachedProfile;

  @override
  Future<void> cacheProfile(ProfileModel profile) async {
    _cachedProfile = profile;
  }

  @override
  Future<ProfileModel?> getCachedProfile() async {
    return _cachedProfile;
  }
}
