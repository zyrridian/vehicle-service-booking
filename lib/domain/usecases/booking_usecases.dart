import '../entities/booking_entities.dart';
import '../repositories/booking_repository.dart';

class GetMyVehiclesUseCase {
  final BookingRepository repository;
  GetMyVehiclesUseCase(this.repository);
  Future<List<VehicleEntity>> execute() => repository.getMyVehicles();
}

class GetAvailableServicesUseCase {
  final BookingRepository repository;
  GetAvailableServicesUseCase(this.repository);
  Future<List<ServiceOptionEntity>> execute(String vehicleId) => repository.getAvailableServices(vehicleId);
}

class GetAvailableTimeSlotsUseCase {
  final BookingRepository repository;
  GetAvailableTimeSlotsUseCase(this.repository);
  Future<List<TimeSlotEntity>> execute(DateTime date) => repository.getAvailableTimeSlots(date);
}

class CreateBookingUseCase {
  final BookingRepository repository;
  CreateBookingUseCase(this.repository);
  Future<String> execute(BookingRequestEntity request) => repository.createBooking(request);
}

class AddTemporaryVehicleUseCase {
  final BookingRepository repository;
  AddTemporaryVehicleUseCase(this.repository);
  Future<VehicleEntity> execute(String name, String plate) => repository.addTemporaryVehicle(name, plate);
}
