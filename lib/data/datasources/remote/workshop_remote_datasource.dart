import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_client.dart';
import '../../models/workshop_model.dart';
import 'package:vehicle_service_booking/domain/entities/workshop_entity.dart';

abstract class WorkshopRemoteDataSource {
  Future<List<WorkshopEntity>> getWorkshops({String? city, String? service, double? lat, double? lon});
  Future<WorkshopEntity> getWorkshopDetail(String id);
}

class WorkshopRemoteDataSourceImpl implements WorkshopRemoteDataSource {
  final NetworkClient _client;

  WorkshopRemoteDataSourceImpl(this._client);

  @override
  Future<List<WorkshopEntity>> getWorkshops({
    String? city,
    String? service,
    double? lat,
    double? lon,
  }) async {
    final queryParams = <String, dynamic>{};
    if (city != null && city.isNotEmpty) queryParams['city'] = city;
    if (service != null && service.isNotEmpty) queryParams['service'] = service;
    if (lat != null) queryParams['lat'] = lat;
    if (lon != null) queryParams['lon'] = lon;

    final responseData = await _client.get(
      ApiEndpoints.workshops,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final List<dynamic> dataList = responseData as List<dynamic>;
    return dataList.map((json) => WorkshopModel.fromJson(json)).toList();
  }

  @override
  Future<WorkshopEntity> getWorkshopDetail(String id) async {
    final responseData = await _client.get('${ApiEndpoints.workshops}/$id');
    return WorkshopModel.fromJson(responseData);
  }
}
