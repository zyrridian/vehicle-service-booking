import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';

class SubmitReviewUseCase {
  final ReviewRepository _repository;

  SubmitReviewUseCase(this._repository);

  Future<ReviewEntity> call({
    required String bookingId,
    required String workshopId,
    required String workshopName,
    required String vehicleName,
    required double rating,
    required String comment,
    required String mechanicName,
  }) {
    return _repository.submitReview(
      bookingId: bookingId,
      workshopId: workshopId,
      workshopName: workshopName,
      vehicleName: vehicleName,
      rating: rating,
      comment: comment,
      mechanicName: mechanicName,
    );
  }
}

class GetReviewsUseCase {
  final ReviewRepository _repository;

  GetReviewsUseCase(this._repository);

  Future<List<ReviewEntity>> call(String workshopId) {
    return _repository.getReviews(workshopId);
  }
}
