import '../entities/review_entity.dart';

abstract class ReviewRepository {
  Future<ReviewEntity> submitReview({
    required String bookingId,
    required String workshopId,
    required String workshopName,
    required String vehicleName,
    required double rating,
    required String comment,
    required String mechanicName,
  });

  Future<List<ReviewEntity>> getReviews(String workshopId);
}
