import '../entities/garage_vehicle_entity.dart';

abstract class GarageRepository {
  Future<List<GarageVehicleEntity>> getGarageVehicles();
  Future<GarageVehicleEntity> getVehicleDetail(String id);
  Future<void> addVehicle(GarageVehicleEntity vehicle);
  Future<void> editVehicle(GarageVehicleEntity vehicle);
  Future<void> deleteVehicle(String id);
}
