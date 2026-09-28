import 'data/datasources/local/auth_local_datasource.dart';
import 'data/datasources/remote/auth_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/verify_otp_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'presentation/auth/bloc/auth_bloc.dart';

import 'data/datasources/account_local_datasource.dart';
import 'data/datasources/account_remote_datasource.dart';
import 'data/repositories/account_repository_impl.dart';
import 'domain/usecases/get_profile_usecase.dart';
import 'domain/usecases/update_profile_usecase.dart';
import 'domain/usecases/get_addresses_usecase.dart';
import 'domain/usecases/add_address_usecase.dart';
import 'domain/usecases/update_address_usecase.dart';
import 'presentation/account/bloc/account_bloc.dart';

import 'data/datasources/remote/notification_remote_datasource.dart';
import 'data/repositories/notification_repository_impl.dart';
import 'domain/usecases/get_notifications_usecase.dart';
import 'presentation/notifications/bloc/notification_bloc.dart';

import 'data/datasources/local/settings_local_datasource.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'domain/usecases/get_settings_usecase.dart';
import 'domain/usecases/update_language_usecase.dart';
import 'presentation/settings/bloc/settings_bloc.dart';

import 'data/datasources/remote/booking_remote_datasource.dart';
import 'data/repositories/booking_repository_impl.dart';
import 'domain/usecases/booking_usecases.dart';
import 'presentation/booking/bloc/booking_bloc.dart';

import 'data/datasources/remote/garage_remote_datasource.dart';
import 'data/repositories/garage_repository_impl.dart';
import 'domain/usecases/garage_usecases.dart';
import 'presentation/garage/bloc/garage_bloc.dart';

class Injection {
  static GarageBloc provideGarageBloc() {
    final remoteDataSource = GarageRemoteDataSourceImpl();
    final repository = GarageRepositoryImpl(remoteDataSource);
    return GarageBloc(
      getGarageVehiclesUseCase: GetGarageVehiclesUseCase(repository),
      getVehicleDetailUseCase: GetVehicleDetailUseCase(repository),
      addVehicleUseCase: AddVehicleUseCase(repository),
      editVehicleUseCase: EditVehicleUseCase(repository),
      deleteVehicleUseCase: DeleteVehicleUseCase(repository),
    );
  }

  static BookingBloc provideBookingBloc() {
    final remoteDataSource = BookingRemoteDataSourceImpl();
    final repository = BookingRepositoryImpl(remoteDataSource);
    return BookingBloc(
      getMyVehiclesUseCase: GetMyVehiclesUseCase(repository),
      getAvailableServicesUseCase: GetAvailableServicesUseCase(repository),
      getAvailableTimeSlotsUseCase: GetAvailableTimeSlotsUseCase(repository),
      createBookingUseCase: CreateBookingUseCase(repository),
      addTemporaryVehicleUseCase: AddTemporaryVehicleUseCase(repository),
    );
  }

  static AuthBloc provideAuthBloc() {
    final remoteDataSource = AuthRemoteDataSourceImpl();
    final localDataSource = AuthLocalDataSourceImpl();
    final repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
    return AuthBloc(
      loginUseCase: LoginUseCase(repository),
      verifyOtpUseCase: VerifyOtpUseCase(repository),
      logoutUseCase: LogoutUseCase(repository),
    );
  }

  static AccountBloc provideAccountBloc() {
    final remoteDataSource = AccountRemoteDataSourceImpl();
    final localDataSource = AccountLocalDataSourceImpl();
    final repository = AccountRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
    return AccountBloc(
      getProfileUseCase: GetProfileUseCase(repository),
      updateProfileUseCase: UpdateProfileUseCase(repository),
      getAddressesUseCase: GetAddressesUseCase(repository),
      addAddressUseCase: AddAddressUseCase(repository),
      updateAddressUseCase: UpdateAddressUseCase(repository),
    );
  }

  static NotificationBloc provideNotificationBloc() {
    final remoteDataSource = NotificationRemoteDataSourceImpl();
    final repository = NotificationRepositoryImpl(remoteDataSource: remoteDataSource);
    return NotificationBloc(
      getNotificationsUseCase: GetNotificationsUseCase(repository),
    );
  }

  static SettingsBloc provideSettingsBloc() {
    final localDataSource = SettingsLocalDataSourceImpl();
    final repository = SettingsRepositoryImpl(localDataSource);
    return SettingsBloc(
      getSettingsUseCase: GetSettingsUseCase(repository),
      updateLanguageUseCase: UpdateLanguageUseCase(repository),
    );
  }
}
