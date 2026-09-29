import '../../../domain/entities/address_entity.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../../domain/entities/settings_entity.dart';

class AccountState {
  final bool isLoading;
  final ProfileEntity? profile;
  final List<AddressEntity>? addresses;
  final SettingsEntity? settings;
  final String? errorMessage;
  final bool isSuccess;

  AccountState({
    this.isLoading = false,
    this.profile,
    this.addresses,
    this.settings,
    this.errorMessage,
    this.isSuccess = false,
  });

  AccountState copyWith({
    bool? isLoading,
    ProfileEntity? profile,
    List<AddressEntity>? addresses,
    SettingsEntity? settings,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return AccountState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      addresses: addresses ?? this.addresses,
      settings: settings ?? this.settings,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? false,
    );
  }
}
