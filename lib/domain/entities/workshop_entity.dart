class WorkshopEntity {
  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final String imageUrl;
  final List<String> services;
  final bool isOpen;
  final String openHours;
  final String phone;
  final List<WorkshopReviewEntity> reviews;

  WorkshopEntity({
    required this.id,
    required this.name,
    this.description = '',
    required this.address,
    required this.city,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.imageUrl,
    required this.services,
    required this.isOpen,
    required this.openHours,
    required this.phone,
    this.reviews = const [],
  });
}

class WorkshopReviewEntity {
  final double rating;
  final String comment;
  final DateTime createdAt;
  final String reviewerName;
  final String? reviewerProfilePictureUrl;

  WorkshopReviewEntity({
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.reviewerName,
    this.reviewerProfilePictureUrl,
  });
}
