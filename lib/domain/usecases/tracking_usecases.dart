import '../entities/tracking_entity.dart';
import '../repositories/tracking_repository.dart';

class GetBookingTrackingUseCase {
  final TrackingRepository _repository;

  GetBookingTrackingUseCase(this._repository);

  Future<BookingTrackingEntity> call(String bookingId) {
    return _repository.getBookingTracking(bookingId);
  }
}
