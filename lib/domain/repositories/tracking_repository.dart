import '../entities/tracking_entity.dart';

abstract class TrackingRepository {
  Future<BookingTrackingEntity> getBookingTracking(String bookingId);
}
