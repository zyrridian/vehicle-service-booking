import 'package:vehicle_service_booking/domain/entities/tracking_entity.dart';

abstract class TrackingRemoteDataSource {
  Future<BookingTrackingEntity> getBookingTracking(String bookingId);
}

class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  @override
  Future<BookingTrackingEntity> getBookingTracking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return BookingTrackingEntity(
      bookingId: bookingId,
      vehicleName: 'Toyota Avanza 2021',
      serviceType: 'Full Service + Oil Change',
      mechanicName: 'Rudi Hartono',
      mechanicPhone: '+62 812-3456-7890',
      mechanicPhotoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      mechanicRating: 4.7,
      estimatedMinutes: 45,
      currentStatus: 'working',
      steps: [
        TrackingStepEntity(
          id: 'step-1',
          title: 'Booking Confirmed',
          description: 'Your service booking has been confirmed.',
          isCompleted: true,
          isActive: false,
          time: '09:00',
        ),
        TrackingStepEntity(
          id: 'step-2',
          title: 'Mechanic Assigned',
          description: 'Rudi Hartono has been assigned to your vehicle.',
          isCompleted: true,
          isActive: false,
          time: '09:15',
        ),
        TrackingStepEntity(
          id: 'step-3',
          title: 'Mechanic On The Way',
          description: 'Your mechanic is heading to the workshop bay.',
          isCompleted: true,
          isActive: false,
          time: '09:30',
        ),
        TrackingStepEntity(
          id: 'step-4',
          title: 'Service In Progress',
          description: 'Your vehicle is currently being serviced.',
          isCompleted: false,
          isActive: true,
          time: '09:45',
        ),
        TrackingStepEntity(
          id: 'step-5',
          title: 'Service Completed',
          description: 'Your vehicle is ready for pickup.',
          isCompleted: false,
          isActive: false,
          time: null,
        ),
      ],
    );
  }
}
