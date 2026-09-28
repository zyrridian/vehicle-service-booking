import 'package:vehicle_service_booking/domain/entities/review_entity.dart';

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
  final List<ReviewEntity> _store = [
    ReviewEntity(
      id: 'rv-001',
      bookingId: 'bk-100',
      workshopId: 'ws-001',
      workshopName: 'AutoCare Pro Workshop',
      vehicleName: 'Honda Jazz 2020',
      rating: 5.0,
      comment:
          'Excellent service! The mechanic was very professional and finished ahead of schedule.',
      datePosted: DateTime(2026, 9, 20),
      mechanicName: 'Rudi Hartono',
    ),
    ReviewEntity(
      id: 'rv-002',
      bookingId: 'bk-099',
      workshopId: 'ws-001',
      workshopName: 'AutoCare Pro Workshop',
      vehicleName: 'Mitsubishi Xpander 2022',
      rating: 4.5,
      comment:
          'Great workshop. Clean facility and transparent pricing. Will definitely come back.',
      datePosted: DateTime(2026, 9, 15),
      mechanicName: 'Andi Setiawan',
    ),
    ReviewEntity(
      id: 'rv-003',
      bookingId: 'bk-098',
      workshopId: 'ws-001',
      workshopName: 'AutoCare Pro Workshop',
      vehicleName: 'Toyota Rush 2019',
      rating: 4.0,
      comment:
          'Good service overall. Took a bit longer than estimated but the quality was solid.',
      datePosted: DateTime(2026, 9, 10),
      mechanicName: 'Budi Santoso',
    ),
    ReviewEntity(
      id: 'rv-004',
      bookingId: 'bk-097',
      workshopId: 'ws-002',
      workshopName: 'Speedy Motors Service',
      vehicleName: 'Suzuki Ertiga 2021',
      rating: 4.5,
      comment:
          'Fast and efficient. The oil change and tire rotation were done in under an hour.',
      datePosted: DateTime(2026, 9, 8),
      mechanicName: 'Doni Pratama',
    ),
    ReviewEntity(
      id: 'rv-005',
      bookingId: 'bk-096',
      workshopId: 'ws-003',
      workshopName: 'EliteTech Auto Center',
      vehicleName: 'BMW 320i 2023',
      rating: 5.0,
      comment:
          'Top-notch service for a premium vehicle. Technicians clearly know what they are doing.',
      datePosted: DateTime(2026, 9, 5),
      mechanicName: 'Fajar Nugroho',
    ),
  ];

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
    await Future.delayed(const Duration(milliseconds: 700));

    final newReview = ReviewEntity(
      id: 'rv-${DateTime.now().millisecondsSinceEpoch}',
      bookingId: bookingId,
      workshopId: workshopId,
      workshopName: workshopName,
      vehicleName: vehicleName,
      rating: rating,
      comment: comment,
      datePosted: DateTime.now(),
      mechanicName: mechanicName,
    );

    _store.add(newReview);
    return newReview;
  }

  @override
  Future<List<ReviewEntity>> getReviews(String workshopId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final filtered =
        _store.where((r) => r.workshopId == workshopId).toList()
          ..sort((a, b) => b.datePosted.compareTo(a.datePosted));

    return filtered;
  }
}
