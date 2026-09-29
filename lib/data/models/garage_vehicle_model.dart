import '../../domain/entities/garage_vehicle_entity.dart';

class GarageVehicleModel extends GarageVehicleEntity {
  GarageVehicleModel({
    required super.id,
    required super.name,
    required super.plate,
    required super.expiry,
    required super.mileage,
    required super.type,
    required super.capacity,
    required super.year,
    required super.nextService,
    required super.status,
    required super.imageUrls,
  });

  factory GarageVehicleModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedImages = [];
    if (json['imageUrls'] != null) {
      parsedImages = List<String>.from(json['imageUrls']);
    } else if (json['imageUrl'] != null) {
      parsedImages = [json['imageUrl'] as String];
    } else if (json['images'] != null) {
      parsedImages = List<String>.from(json['images']);
    }
    
    return GarageVehicleModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      plate: json['plate'] ?? '',
      expiry: json['expiry'] ?? '',
      mileage: json['mileage'] ?? '',
      type: json['type'] ?? '',
      capacity: json['capacity'] ?? '',
      year: json['year'] ?? '',
      nextService: json['nextService'] ?? '',
      status: json['status'] ?? '',
      imageUrls: parsedImages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'plate': plate,
      'expiry': expiry,
      'mileage': mileage,
      'type': type,
      'capacity': capacity,
      'year': year,
      'nextService': nextService,
      'status': status,
      'imageUrls': imageUrls,
    };
  }
}
