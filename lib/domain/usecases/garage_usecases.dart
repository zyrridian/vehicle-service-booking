import '../entities/garage_vehicle_entity.dart';
import '../repositories/garage_repository.dart';

class GetGarageVehiclesUseCase {
  final GarageRepository repository;
  GetGarageVehiclesUseCase(this.repository);
  Future<List<GarageVehicleEntity>> execute() => repository.getGarageVehicles();
}

class GetVehicleDetailUseCase {
  final GarageRepository repository;
  GetVehicleDetailUseCase(this.repository);
  Future<GarageVehicleEntity> execute(String id) => repository.getVehicleDetail(id);
}

class AddVehicleUseCase {
  final GarageRepository repository;
  AddVehicleUseCase(this.repository);
  Future<GarageVehicleEntity> execute(GarageVehicleEntity vehicle) => repository.addVehicle(vehicle);
}

class EditVehicleUseCase {
  final GarageRepository repository;
  EditVehicleUseCase(this.repository);
  Future<GarageVehicleEntity> execute(GarageVehicleEntity vehicle) => repository.editVehicle(vehicle);
}

class DeleteVehicleUseCase {
  final GarageRepository repository;
  DeleteVehicleUseCase(this.repository);
  Future<void> execute(String id) => repository.deleteVehicle(id);
}
