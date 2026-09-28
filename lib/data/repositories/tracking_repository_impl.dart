import 'package:vehicle_service_booking/data/datasources/remote/tracking_remote_datasource.dart';
import 'package:vehicle_service_booking/domain/entities/tracking_entity.dart';
import 'package:vehicle_service_booking/domain/repositories/tracking_repository.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDataSource _remoteDataSource;

  TrackingRepositoryImpl(this._remoteDataSource);

  @override
  Future<BookingTrackingEntity> getBookingTracking(String bookingId) {
    return _remoteDataSource.getBookingTracking(bookingId);
  }
}
