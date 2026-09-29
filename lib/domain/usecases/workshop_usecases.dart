import '../entities/workshop_entity.dart';
import '../repositories/workshop_repository.dart';

class GetWorkshopsUseCase {
  final WorkshopRepository _repository;

  GetWorkshopsUseCase(this._repository);

  Future<List<WorkshopEntity>> call({String? city, String? service, double? lat, double? lon}) {
    return _repository.getWorkshops(city: city, service: service, lat: lat, lon: lon);
  }
}

class GetWorkshopDetailUseCase {
  final WorkshopRepository _repository;

  GetWorkshopDetailUseCase(this._repository);

  Future<WorkshopEntity> call(String id) {
    return _repository.getWorkshopDetail(id);
  }
}
