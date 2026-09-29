import '../../domain/entities/workshop_entity.dart';

class WorkshopModel extends WorkshopEntity {
  WorkshopModel({
    required super.id,
    required super.name,
    super.description = '',
    required super.address,
    required super.city,
    required super.rating,
    required super.reviewCount,
    required super.distanceKm,
    required super.imageUrl,
    required super.services,
    required super.isOpen,
    required super.openHours,
    required super.phone,
    super.reviews = const [],
  });

  factory WorkshopModel.fromJson(Map<String, dynamic> json) {
    List<WorkshopReviewEntity> parsedReviews = [];
    if (json['reviews'] != null) {
      parsedReviews = (json['reviews'] as List).map((r) => WorkshopReviewModel.fromJson(r)).toList();
    }

    return WorkshopModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      distanceKm: (json['distanceKm'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? 'https://images.unsplash.com/photo-1625047509168-a7026f36de04?w=300&q=80',
      services: json['services'] != null ? List<String>.from(json['services']) : [],
      isOpen: json['isOpen'] ?? true,
      openHours: json['openHours'] ?? '09:00 - 17:00',
      phone: json['phone'] ?? '',
      reviews: parsedReviews,
    );
  }
}

class WorkshopReviewModel extends WorkshopReviewEntity {
  WorkshopReviewModel({
    required super.rating,
    required super.comment,
    required super.createdAt,
    required super.reviewerName,
    super.reviewerProfilePictureUrl,
  });

  factory WorkshopReviewModel.fromJson(Map<String, dynamic> json) {
    final userObj = json['user'] as Map<String, dynamic>? ?? {};
    return WorkshopReviewModel(
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      reviewerName: userObj['name'] ?? 'Anonymous',
      reviewerProfilePictureUrl: userObj['profilePictureUrl'],
    );
  }
}
