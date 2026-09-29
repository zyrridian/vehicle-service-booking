class GarageVehicleEntity {
  final String id;
  final String name;
  final String plate;
  final String expiry;
  final String mileage;
  final String type;
  final String capacity;
  final String year;
  final String nextService;
  final String status;
  final List<String> imageUrls;

  GarageVehicleEntity({
    required this.id,
    required this.name,
    required this.plate,
    required this.expiry,
    required this.mileage,
    required this.type,
    required this.capacity,
    required this.year,
    required this.nextService,
    required this.status,
    required this.imageUrls,
  });
}
