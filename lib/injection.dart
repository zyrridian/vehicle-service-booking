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

import 'data/datasources/remote/booking_remote_datasource.dart';
import 'data/repositories/booking_repository_impl.dart';
import 'domain/usecases/booking_usecases.dart';
import 'presentation/booking/bloc/booking_bloc.dart';

import 'data/datasources/remote/garage_remote_datasource.dart';
import 'data/repositories/garage_repository_impl.dart';
import 'domain/usecases/garage_usecases.dart';
import 'presentation/garage/bloc/garage_bloc.dart';

import 'data/datasources/remote/workshop_remote_datasource.dart';
import 'data/repositories/workshop_repository_impl.dart';
import 'domain/usecases/workshop_usecases.dart';
import 'presentation/workshop/bloc/workshop_bloc.dart';

import 'data/datasources/remote/tracking_remote_datasource.dart';
import 'data/repositories/tracking_repository_impl.dart';
import 'domain/usecases/tracking_usecases.dart';
import 'presentation/tracking/bloc/tracking_bloc.dart';

import 'data/datasources/remote/invoice_remote_datasource.dart';
import 'data/repositories/invoice_repository_impl.dart';
import 'domain/usecases/invoice_usecases.dart';
import 'presentation/invoice/bloc/invoice_bloc.dart';

import 'data/datasources/remote/review_remote_datasource.dart';
import 'data/repositories/review_repository_impl.dart';
import 'domain/usecases/review_usecases.dart';
import 'presentation/review/bloc/review_bloc.dart';

import 'data/datasources/remote/history_remote_datasource.dart';
import 'data/repositories/history_repository_impl.dart';
import 'domain/usecases/get_history_usecases.dart';
import 'presentation/history/bloc/history_bloc.dart';

class Injection {
  static HistoryBloc provideHistoryBloc() {
    final remoteDataSource = HistoryRemoteDataSourceImpl();
    final repository = HistoryRepositoryImpl(remoteDataSource);
    return HistoryBloc(
      getHistoryBookingsUseCase: GetHistoryBookingsUseCase(repository),
    );
  }
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

  static WorkshopBloc provideWorkshopBloc() {
    final remoteDataSource = WorkshopRemoteDataSourceImpl();
    final repository = WorkshopRepositoryImpl(remoteDataSource);
    return WorkshopBloc(
      getWorkshopsUseCase: GetWorkshopsUseCase(repository),
      getWorkshopDetailUseCase: GetWorkshopDetailUseCase(repository),
    );
  }

  static TrackingBloc provideTrackingBloc() {
    final remoteDataSource = TrackingRemoteDataSourceImpl();
    final repository = TrackingRepositoryImpl(remoteDataSource);
    return TrackingBloc(
      getBookingTrackingUseCase: GetBookingTrackingUseCase(repository),
    );
  }

  static InvoiceBloc provideInvoiceBloc() {
    final remoteDataSource = InvoiceRemoteDataSourceImpl();
    final repository = InvoiceRepositoryImpl(remoteDataSource);
    return InvoiceBloc(
      getInvoiceUseCase: GetInvoiceUseCase(repository),
    );
  }

  static ReviewBloc provideReviewBloc() {
    final remoteDataSource = ReviewRemoteDataSourceImpl();
    final repository = ReviewRepositoryImpl(remoteDataSource);
    return ReviewBloc(
      submitReviewUseCase: SubmitReviewUseCase(repository),
      getReviewsUseCase: GetReviewsUseCase(repository),
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
    
    final settingsLocalDataSource = SettingsLocalDataSourceImpl();
    final settingsRepository = SettingsRepositoryImpl(settingsLocalDataSource);

    return AccountBloc(
      getProfileUseCase: GetProfileUseCase(repository),
      updateProfileUseCase: UpdateProfileUseCase(repository),
      getAddressesUseCase: GetAddressesUseCase(repository),
      addAddressUseCase: AddAddressUseCase(repository),
      updateAddressUseCase: UpdateAddressUseCase(repository),
      getSettingsUseCase: GetSettingsUseCase(settingsRepository),
      updateLanguageUseCase: UpdateLanguageUseCase(settingsRepository),
    );
  }

  static NotificationBloc provideNotificationBloc() {
    final remoteDataSource = NotificationRemoteDataSourceImpl();
    final repository = NotificationRepositoryImpl(remoteDataSource: remoteDataSource);
    return NotificationBloc(
      getNotificationsUseCase: GetNotificationsUseCase(repository),
    );
  }
}
