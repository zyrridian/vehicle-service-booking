import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/address_entity.dart';
import '../../../domain/usecases/get_addresses_usecase.dart';
import '../../../domain/usecases/get_profile_usecase.dart';
import '../../../domain/usecases/update_profile_usecase.dart';
import '../../../domain/usecases/add_address_usecase.dart';
import '../../../domain/usecases/update_address_usecase.dart';
import '../../../domain/usecases/get_settings_usecase.dart';
import '../../../domain/usecases/update_language_usecase.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetProfileUseCase getProfileUseCase;
  final GetAddressesUseCase getAddressesUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final GetSettingsUseCase getSettingsUseCase;
  final UpdateLanguageUseCase updateLanguageUseCase;

  AccountBloc({
    required this.getProfileUseCase,
    required this.getAddressesUseCase,
    required this.updateProfileUseCase,
    required this.addAddressUseCase,
    required this.updateAddressUseCase,
    required this.getSettingsUseCase,
    required this.updateLanguageUseCase,
  }) : super(AccountState()) {
    on<FetchProfileRequested>(_onFetchProfileRequested);
    on<FetchAddressesRequested>(_onFetchAddressesRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<AddAddressRequested>(_onAddAddressRequested);
    on<UpdateAddressRequested>(_onUpdateAddressRequested);
    on<LoadSettingsRequested>(_onLoadSettingsRequested);
    on<ChangeLanguageRequested>(_onChangeLanguageRequested);
  }

  Future<void> _onFetchProfileRequested(FetchProfileRequested event, Emitter<AccountState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final profile = await getProfileUseCase.execute();
      emit(state.copyWith(isLoading: false, profile: profile));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchAddressesRequested(FetchAddressesRequested event, Emitter<AccountState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final addresses = await getAddressesUseCase.execute();
      emit(state.copyWith(isLoading: false, addresses: addresses));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateProfileRequested(UpdateProfileRequested event, Emitter<AccountState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final profile = await updateProfileUseCase.execute(event.updatedProfile);
      emit(state.copyWith(isLoading: false, profile: profile, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddAddressRequested(AddAddressRequested event, Emitter<AccountState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final newAddress = await addAddressUseCase.execute(event.address);
      final currentAddresses = List<AddressEntity>.from(state.addresses ?? []);
      
      if (newAddress.isDefault) {
        for (int i = 0; i < currentAddresses.length; i++) {
          currentAddresses[i] = AddressEntity(
            id: currentAddresses[i].id,
            label: currentAddresses[i].label,
            fullAddress: currentAddresses[i].fullAddress,
            isDefault: false,
          );
        }
      }
      
      currentAddresses.add(newAddress);
      emit(state.copyWith(isLoading: false, addresses: currentAddresses, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateAddressRequested(UpdateAddressRequested event, Emitter<AccountState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final updatedAddress = await updateAddressUseCase.execute(event.address);
      final currentAddresses = List<AddressEntity>.from(state.addresses ?? []);
      
      final index = currentAddresses.indexWhere((a) => a.id == updatedAddress.id);
      if (index != -1) {
        if (updatedAddress.isDefault) {
          for (int i = 0; i < currentAddresses.length; i++) {
            currentAddresses[i] = AddressEntity(
              id: currentAddresses[i].id,
              label: currentAddresses[i].label,
              fullAddress: currentAddresses[i].fullAddress,
              isDefault: false,
            );
          }
        }
        currentAddresses[index] = updatedAddress;
      }
      
      emit(state.copyWith(isLoading: false, addresses: currentAddresses, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadSettingsRequested(LoadSettingsRequested event, Emitter<AccountState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final settings = await getSettingsUseCase.execute();
      emit(state.copyWith(isLoading: false, settings: settings));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onChangeLanguageRequested(ChangeLanguageRequested event, Emitter<AccountState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await updateLanguageUseCase.execute(event.languageCode);
      final updatedSettings = await getSettingsUseCase.execute();
      emit(state.copyWith(isLoading: false, settings: updatedSettings));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
