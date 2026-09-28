import 'dart:convert';
import '../models/address_model.dart';
import '../models/profile_model.dart';

abstract class AccountRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(ProfileModel profile);
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> addAddress(AddressModel address);
  Future<AddressModel> updateAddress(AddressModel address);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  @override
  Future<ProfileModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 800));
    const jsonResponse = '''
    {
      "id": "USR-99812",
      "name": "Dimas Pratama",
      "phone": "+62 812 3456 7890",
      "email": "dimas.pratama@example.com"
    }
    ''';
    return ProfileModel.fromJson(jsonDecode(jsonResponse));
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return profile;
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    await Future.delayed(const Duration(milliseconds: 800));
    const jsonResponse = '''
    [
      {
        "id": "ADDR-1",
        "label": "Home",
        "fullAddress": "Jl. Merdeka No. 45, Bandung, Jawa Barat 40111",
        "isDefault": true
      },
      {
        "id": "ADDR-2",
        "label": "Office",
        "fullAddress": "Gedung Sate Lt 2, Jl. Diponegoro No. 22, Bandung, Jawa Barat 40115",
        "isDefault": false
      }
    ]
    ''';
    final List<dynamic> decoded = jsonDecode(jsonResponse);
    return decoded.map((json) => AddressModel.fromJson(json)).toList();
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return AddressModel(
      id: 'ADDR-${DateTime.now().millisecondsSinceEpoch}',
      label: address.label,
      fullAddress: address.fullAddress,
      isDefault: address.isDefault,
    );
  }

  @override
  Future<AddressModel> updateAddress(AddressModel address) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return address;
  }
}
