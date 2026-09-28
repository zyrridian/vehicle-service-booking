class WorkshopEntity {
  final String id;
  final String name;
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

  WorkshopEntity({
    required this.id,
    required this.name,
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
  });
}
