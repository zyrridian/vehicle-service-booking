import 'package:vehicle_service_booking/domain/entities/garage_vehicle_entity.dart';

abstract class GarageRemoteDataSource {
  Future<List<GarageVehicleEntity>> getGarageVehicles();
  Future<GarageVehicleEntity> getVehicleDetail(String id);
  Future<void> addVehicle(GarageVehicleEntity vehicle);
  Future<void> editVehicle(GarageVehicleEntity vehicle);
  Future<void> deleteVehicle(String id);
}

class GarageRemoteDataSourceImpl implements GarageRemoteDataSource {
  // In-memory cache for simulation
  final List<GarageVehicleEntity> _vehicles = [
    GarageVehicleEntity(
      id: 'v1',
      name: 'Honda Vario 150',
      plate: 'B 4567 ABC',
      expiry: '10/28',
      mileage: '14500',
      type: 'Scooter / Matic',
      capacity: '150',
      year: '2019',
      nextService: 'Oct 15, 2026',
      status: 'Good',
      imageUrl: 'https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=300&q=80',
    ),
    GarageVehicleEntity(
      id: 'v2',
      name: 'Yamaha NMAX 155',
      plate: 'D 1234 XYZ',
      expiry: '11/27',
      mileage: '8200',
      type: 'Maxi Scooter',
      capacity: '155',
      year: '2021',
      nextService: 'Nov 02, 2026',
      status: 'Check',
      imageUrl: 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=300&q=80',
    ),
    GarageVehicleEntity(
      id: 'v3',
      name: 'Kawasaki Ninja 250',
      plate: 'B 9999 KAW',
      expiry: '09/29',
      mileage: '21000',
      type: 'Sport',
      capacity: '250',
      year: '2018',
      nextService: 'Sep 20, 2026',
      status: 'Good',
      imageUrl: 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=300&q=80',
    ),
  ];

  @override
  Future<List<GarageVehicleEntity>> getGarageVehicles() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _vehicles;
  }

  @override
  Future<GarageVehicleEntity> getVehicleDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _vehicles.firstWhere((v) => v.id == id);
  }

  @override
  Future<void> addVehicle(GarageVehicleEntity vehicle) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _vehicles.add(vehicle);
  }

  @override
  Future<void> editVehicle(GarageVehicleEntity vehicle) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      _vehicles[index] = vehicle;
    }
  }

  @override
  Future<void> deleteVehicle(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _vehicles.removeWhere((v) => v.id == id);
  }
}
