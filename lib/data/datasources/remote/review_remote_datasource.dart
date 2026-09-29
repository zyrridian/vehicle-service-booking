import 'package:vehicle_service_booking/domain/entities/review_entity.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_client.dart';

abstract class ReviewRemoteDataSource {
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

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final NetworkClient _client;

  ReviewRemoteDataSourceImpl(this._client);

  @override
  Future<ReviewEntity> submitReview({
    required String bookingId,
    required String workshopId,
    required String workshopName,
    required String vehicleName,
    required double rating,
    required String comment,
    required String mechanicName,
  }) async {
    final body = {
      "bookingId": bookingId,
      "workshopId": workshopId,
      "rating": rating,
      "comment": comment,
    };
    
    final response = await _client.post(ApiEndpoints.reviews, data: body);
    
    return ReviewEntity(
      id: 'generated-by-backend',
      bookingId: bookingId,
      workshopId: workshopId,
      workshopName: workshopName,
      vehicleName: vehicleName,
      rating: rating,
      comment: comment,
      datePosted: DateTime.now(),
      mechanicName: mechanicName,
    );
  }

  @override
  Future<List<ReviewEntity>> getReviews(String workshopId) async {
    try {
      final response = await _client.get(ApiEndpoints.reviews, queryParameters: {'workshopId': workshopId});
      final List<dynamic> data = response;
      return data.map((r) => ReviewEntity(
        id: r['id'] ?? '',
        bookingId: r['bookingId'] ?? '',
        workshopId: r['workshopId'] ?? '',
        workshopName: r['workshopName'] ?? '',
        vehicleName: r['vehicleName'] ?? '',
        rating: (r['rating'] ?? 0).toDouble(),
        comment: r['comment'] ?? '',
        datePosted: r['createdAt'] != null ? DateTime.parse(r['createdAt']) : DateTime.now(),
        mechanicName: r['mechanicName'] ?? 'Mechanic',
      )).toList();
    } catch (e) {
      return [];
    }
  }
}
