import 'package:vehicle_service_booking/data/datasources/remote/review_remote_datasource.dart';
import 'package:vehicle_service_booking/domain/entities/review_entity.dart';
import 'package:vehicle_service_booking/domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource _remoteDataSource;

  ReviewRepositoryImpl(this._remoteDataSource);

  @override
  Future<ReviewEntity> submitReview({
    required String bookingId,
    required String workshopId,
    required String workshopName,
    required String vehicleName,
    required double rating,
    required String comment,
    required String mechanicName,
  }) {
    return _remoteDataSource.submitReview(
      bookingId: bookingId,
      workshopId: workshopId,
      workshopName: workshopName,
      vehicleName: vehicleName,
      rating: rating,
      comment: comment,
      mechanicName: mechanicName,
    );
  }

  @override
  Future<List<ReviewEntity>> getReviews(String workshopId) {
    return _remoteDataSource.getReviews(workshopId);
  }
}
