import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_client.dart';
import '../local/auth_local_datasource.dart';
import '../../models/address_model.dart';
import '../../models/profile_model.dart';
import '../../models/user_model.dart';
import 'dart:convert';

import 'package:dio/dio.dart';

abstract class AccountRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(ProfileModel profile);
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> addAddress(AddressModel address);
  Future<AddressModel> updateAddress(AddressModel address);
  Future<void> deleteAddress(String addressId);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final NetworkClient _client;
  final AuthLocalDataSource _authLocalDataSource;

  AccountRemoteDataSourceImpl(this._client, this._authLocalDataSource);

  @override
  Future<ProfileModel> getProfile() async {
    final session = await _authLocalDataSource.getSession();
    if (session == null) throw Exception("Unauthorized");

    final responseData = await _client.get(
      ApiEndpoints.userProfile,
      queryParameters: {"userId": session.id},
    );
    return ProfileModel.fromJson(responseData);
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    final session = await _authLocalDataSource.getSession();
    if (session == null) throw Exception("Unauthorized");

    final formData = FormData.fromMap({
      "userId": session.id,
      "name": profile.name,
      "email": profile.email,
    });

    if (profile.profilePictureUrl != null && profile.profilePictureUrl!.isNotEmpty) {
      if (!profile.profilePictureUrl!.startsWith('http')) {
        formData.files.add(MapEntry(
          'profilePicture',
          await MultipartFile.fromFile(profile.profilePictureUrl!),
        ));
      }
    }

    final responseData = await _client.put(
      ApiEndpoints.userProfile,
      data: formData,
    );

    if (session.isNewUser) {
      await _authLocalDataSource.cacheSession(
        UserModel(
          id: session.id,
          name: profile.name,
          phone: session.phone,
          token: session.token,
          isNewUser: false,
        ),
      );
    }

    return ProfileModel.fromJson(responseData);
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    final session = await _authLocalDataSource.getSession();
    if (session == null) throw Exception("Unauthorized");

    final responseData = await _client.get(
      ApiEndpoints.addresses,
      queryParameters: {"userId": session.id},
    );
    
    final List<dynamic> dataList = responseData as List<dynamic>;
    return dataList.map((json) => AddressModel.fromJson(json)).toList();
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    final session = await _authLocalDataSource.getSession();
    if (session == null) throw Exception("Unauthorized");

    final responseData = await _client.post(
      ApiEndpoints.addresses,
      data: {
        "userId": session.id,
        "label": address.label,
        "fullAddress": address.fullAddress,
        "isDefault": address.isDefault,
      },
    );
    return AddressModel.fromJson(responseData);
  }

  @override
  Future<AddressModel> updateAddress(AddressModel address) async {
    final responseData = await _client.put(
      '${ApiEndpoints.addresses}/${address.id}',
      data: {
        "label": address.label,
        "fullAddress": address.fullAddress,
        "isDefault": address.isDefault,
      },
    );
    return AddressModel.fromJson(responseData);
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    await _client.delete('${ApiEndpoints.addresses}/$addressId');
  }
}
