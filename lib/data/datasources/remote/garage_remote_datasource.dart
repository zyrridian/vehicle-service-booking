import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_client.dart';
import '../local/auth_local_datasource.dart';
import '../../models/garage_vehicle_model.dart';
import 'package:vehicle_service_booking/domain/entities/garage_vehicle_entity.dart';

abstract class GarageRemoteDataSource {
  Future<List<GarageVehicleEntity>> getGarageVehicles();
  Future<GarageVehicleEntity> getVehicleDetail(String id);
  Future<GarageVehicleEntity> addVehicle(GarageVehicleEntity vehicle);
  Future<GarageVehicleEntity> editVehicle(GarageVehicleEntity vehicle);
  Future<void> deleteVehicle(String id);
}

class GarageRemoteDataSourceImpl implements GarageRemoteDataSource {
  final NetworkClient _client;
  final AuthLocalDataSource _authLocalDataSource;

  GarageRemoteDataSourceImpl(this._client, this._authLocalDataSource);

  @override
  Future<List<GarageVehicleEntity>> getGarageVehicles() async {
    final session = await _authLocalDataSource.getSession();
    if (session == null) throw Exception("Unauthorized");

    final responseData = await _client.get(
      ApiEndpoints.garageVehicles,
      queryParameters: {"userId": session.id},
    );

    final List<dynamic> dataList = responseData as List<dynamic>;
    return dataList.map((json) => GarageVehicleModel.fromJson(json)).toList();
  }

  @override
  Future<GarageVehicleEntity> getVehicleDetail(String id) async {
    final responseData = await _client.get('${ApiEndpoints.garageVehicles}/$id');
    return GarageVehicleModel.fromJson(responseData);
  }

  @override
  Future<GarageVehicleEntity> addVehicle(GarageVehicleEntity vehicle) async {
    final session = await _authLocalDataSource.getSession();
    if (session == null) throw Exception("Unauthorized");

    final responseData = await _client.post(
      ApiEndpoints.garageVehicles,
      data: {
        "userId": session.id,
        "name": vehicle.name,
        "plate": vehicle.plate,
        "expiry": vehicle.expiry,
        "mileage": vehicle.mileage,
        "type": vehicle.type,
        "capacity": vehicle.capacity,
        "year": vehicle.year,
        "nextService": vehicle.nextService,
        "status": vehicle.status,
        "imageUrls": vehicle.imageUrls,
      },
    );
    return GarageVehicleModel.fromJson(responseData);
  }

  @override
  Future<GarageVehicleEntity> editVehicle(GarageVehicleEntity vehicle) async {
    final responseData = await _client.put(
      '${ApiEndpoints.garageVehicles}/${vehicle.id}',
      data: {
        "name": vehicle.name,
        "plate": vehicle.plate,
        "expiry": vehicle.expiry,
        "mileage": vehicle.mileage,
        "type": vehicle.type,
        "capacity": vehicle.capacity,
        "year": vehicle.year,
        "nextService": vehicle.nextService,
        "status": vehicle.status,
        "imageUrls": vehicle.imageUrls,
      },
    );
    return GarageVehicleModel.fromJson(responseData);
  }

  @override
  Future<void> deleteVehicle(String id) async {
    await _client.delete('${ApiEndpoints.garageVehicles}/$id');
  }
}
