import '../../domain/entities/booking_entities.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/remote/booking_remote_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<VehicleEntity>> getMyVehicles() => remoteDataSource.getMyVehicles();

  @override
  Future<List<ServiceOptionEntity>> getAvailableServices(String vehicleId) => remoteDataSource.getAvailableServices(vehicleId);

  @override
  Future<List<TimeSlotEntity>> getAvailableTimeSlots(DateTime date) => remoteDataSource.getAvailableTimeSlots(date);

  @override
  Future<VehicleEntity> addTemporaryVehicle(String name, String plate) => remoteDataSource.addTemporaryVehicle(name, plate);

  @override
  Future<String> createBooking(BookingRequestEntity request) => remoteDataSource.createBooking(request);
}
