import '../../../domain/entities/profile_entity.dart';
import '../../../domain/entities/address_entity.dart';

abstract class AccountEvent {}

class FetchProfileRequested extends AccountEvent {}

class FetchAddressesRequested extends AccountEvent {}

class UpdateProfileRequested extends AccountEvent {
  final ProfileEntity updatedProfile;
  UpdateProfileRequested(this.updatedProfile);
}

class AddAddressRequested extends AccountEvent {
  final AddressEntity address;
  AddAddressRequested(this.address);
}

class UpdateAddressRequested extends AccountEvent {
  final AddressEntity address;
  UpdateAddressRequested(this.address);
}

class LoadSettingsRequested extends AccountEvent {}

class ChangeLanguageRequested extends AccountEvent {
  final String languageCode;
  ChangeLanguageRequested(this.languageCode);
}

class DeleteAddressRequested extends AccountEvent {
  final String addressId;
  DeleteAddressRequested(this.addressId);
}
