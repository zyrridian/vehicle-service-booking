import '../../domain/entities/garage_vehicle_entity.dart';
import '../../domain/repositories/garage_repository.dart';
import '../datasources/remote/garage_remote_datasource.dart';

class GarageRepositoryImpl implements GarageRepository {
  final GarageRemoteDataSource remoteDataSource;

  GarageRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<GarageVehicleEntity>> getGarageVehicles() => remoteDataSource.getGarageVehicles();

  @override
  Future<GarageVehicleEntity> getVehicleDetail(String id) => remoteDataSource.getVehicleDetail(id);

  @override
  Future<GarageVehicleEntity> addVehicle(GarageVehicleEntity vehicle) => remoteDataSource.addVehicle(vehicle);

  @override
  Future<GarageVehicleEntity> editVehicle(GarageVehicleEntity vehicle) => remoteDataSource.editVehicle(vehicle);

  @override
  Future<void> deleteVehicle(String id) => remoteDataSource.deleteVehicle(id);
}
