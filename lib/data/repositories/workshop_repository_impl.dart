import 'package:vehicle_service_booking/data/datasources/remote/workshop_remote_datasource.dart';
import 'package:vehicle_service_booking/domain/entities/workshop_entity.dart';
import 'package:vehicle_service_booking/domain/repositories/workshop_repository.dart';

class WorkshopRepositoryImpl implements WorkshopRepository {
  final WorkshopRemoteDataSource _remoteDataSource;

  WorkshopRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<WorkshopEntity>> getWorkshops({
    String? city,
    String? service,
    double? lat,
    double? lon,
  }) {
    return _remoteDataSource.getWorkshops(city: city, service: service, lat: lat, lon: lon);
  }

  @override
  Future<WorkshopEntity> getWorkshopDetail(String id) {
    return _remoteDataSource.getWorkshopDetail(id);
  }
}
