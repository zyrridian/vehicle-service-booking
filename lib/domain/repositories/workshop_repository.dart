import '../entities/workshop_entity.dart';

abstract class WorkshopRepository {
  Future<List<WorkshopEntity>> getWorkshops({String? city, String? service, double? lat, double? lon});
  Future<WorkshopEntity> getWorkshopDetail(String id);
}
