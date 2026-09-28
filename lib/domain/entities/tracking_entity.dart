class TrackingStepEntity {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final bool isActive;
  final String? time;

  TrackingStepEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.isActive,
    this.time,
  });
}

class BookingTrackingEntity {
  final String bookingId;
  final String vehicleName;
  final String serviceType;
  final String mechanicName;
  final String mechanicPhone;
  final String mechanicPhotoUrl;
  final double mechanicRating;
  final int estimatedMinutes;
  final List<TrackingStepEntity> steps;
  final String currentStatus;

  BookingTrackingEntity({
    required this.bookingId,
    required this.vehicleName,
    required this.serviceType,
    required this.mechanicName,
    required this.mechanicPhone,
    required this.mechanicPhotoUrl,
    required this.mechanicRating,
    required this.estimatedMinutes,
    required this.steps,
    required this.currentStatus,
  });
}
