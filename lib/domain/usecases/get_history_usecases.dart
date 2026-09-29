import '../entities/history_entity.dart';
import '../repositories/history_repository.dart';

class GetHistoryBookingsUseCase {
  final HistoryRepository repository;

  GetHistoryBookingsUseCase(this.repository);

  Future<List<HistoryBookingEntity>> execute() async {
    return await repository.getHistoryBookings();
  }
}
