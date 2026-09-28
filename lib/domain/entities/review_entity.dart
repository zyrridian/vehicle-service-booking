class ReviewEntity {
  final String id;
  final String bookingId;
  final String workshopId;
  final String workshopName;
  final String vehicleName;
  final double rating;
  final String comment;
  final DateTime datePosted;
  final String mechanicName;

  ReviewEntity({
    required this.id,
    required this.bookingId,
    required this.workshopId,
    required this.workshopName,
    required this.vehicleName,
    required this.rating,
    required this.comment,
    required this.datePosted,
    required this.mechanicName,
  });
}
