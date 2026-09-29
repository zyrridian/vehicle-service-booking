import 'package:vehicle_service_booking/domain/entities/tracking_entity.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_client.dart';

abstract class TrackingRemoteDataSource {
  Future<BookingTrackingEntity> getBookingTracking(String bookingId);
}

class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  final NetworkClient _client;

  TrackingRemoteDataSourceImpl(this._client);

  @override
  Future<BookingTrackingEntity> getBookingTracking(String bookingId) async {
    final response = await _client.get('${ApiEndpoints.tracking}/$bookingId');
    final data = response as Map<String, dynamic>;

    return BookingTrackingEntity(
      bookingId: bookingId,
      vehicleName: data['vehicleName'] ?? 'Unknown Vehicle',
      serviceType: data['serviceType'] ?? 'Unknown Service',
      mechanicName: data['mechanicName'] ?? 'Pending Mechanic',
      mechanicPhone: data['mechanicPhone'] ?? '-',
      mechanicPhotoUrl: data['mechanicPhotoUrl'],
      mechanicRating: (data['mechanicRating'] ?? 0).toDouble(),
      estimatedMinutes: data['estimatedMinutes'] ?? 0,
      currentStatus: data['currentStatus'] ?? 'scheduled',
      steps: _generateFallbackSteps(data['currentStatus'] ?? 'scheduled'),
    );
  }

  List<TrackingStepEntity> _generateFallbackSteps(String currentStatus) {
    final statusList = ['confirmed', 'assigned', 'on_the_way', 'working', 'completed'];
    final s = currentStatus.toLowerCase();
    
    int currentIndex = statusList.indexOf(s);
    if (currentIndex == -1) currentIndex = 0;

    return [
      TrackingStepEntity(id: '1', title: 'Booking Confirmed', description: 'Confirmed', isCompleted: currentIndex >= 0, isActive: currentIndex == 0, time: ''),
      TrackingStepEntity(id: '2', title: 'Mechanic Assigned', description: 'Assigned', isCompleted: currentIndex >= 1, isActive: currentIndex == 1, time: ''),
      TrackingStepEntity(id: '3', title: 'Mechanic On The Way', description: 'On the way', isCompleted: currentIndex >= 2, isActive: currentIndex == 2, time: ''),
      TrackingStepEntity(id: '4', title: 'Service In Progress', description: 'Working', isCompleted: currentIndex >= 3, isActive: currentIndex == 3, time: ''),
      TrackingStepEntity(id: '5', title: 'Service Completed', description: 'Done', isCompleted: currentIndex >= 4, isActive: currentIndex == 4, time: ''),
    ];
  }
}
