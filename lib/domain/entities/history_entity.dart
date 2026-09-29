class HistoryBookingEntity {
  final String bookingId;
  final String vehicleName;
  final String serviceType;
  final String dateTime;
  final String location;
  final String total;
  final String status;
  final String imageUrl;
  final bool isActive;

  HistoryBookingEntity({
    required this.bookingId,
    required this.vehicleName,
    required this.serviceType,
    required this.dateTime,
    required this.location,
    required this.total,
    required this.status,
    required this.imageUrl,
    required this.isActive,
  });
}
